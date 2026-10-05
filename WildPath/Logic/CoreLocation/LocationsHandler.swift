import CoreLocation
import Observation
import OSLog
import UserNotifications

@MainActor
@Observable
final class LocationsHandler
{
    static let shared = LocationsHandler()

    private let logger = Logger(
        subsystem: "com.apple.liveUpdatesSample",
        category: "LocationsHandler"
    )
    
    private let notificationCenter = UNUserNotificationCenter.current()
    private let notificationContent: UNMutableNotificationContent

    private(set) var lastUpdate: CLLocationUpdate?
    private(set) var lastLocation = CLLocation()
    private(set) var count = 0
    private(set) var isStationary = false

    @ObservationIgnored
    private var locationUpdatesTask: Task<Void, Never>?

    private init()
    {
        let content = UNMutableNotificationContent()
        content.title = "Location updates inactive"
        content.body = "Can't receive location updates while not in the foreground"
        notificationContent = content

        Task
        {
            do
            {
                try await notificationCenter.requestAuthorization(options: [.badge])
            }
            catch
            {
                logger.error("Could not request notification authorization: \(error.localizedDescription)")
            }
        }
    }

    func startLocationUpdates()
    {
        guard locationUpdatesTask == nil else
        {
            return
        }

        logger.info("Starting location updates")

        locationUpdatesTask = Task
        { [weak self] in
            guard let self else
            {
                return
            }

            defer
            {
                locationUpdatesTask = nil
            }

            do
            {
                for try await update in CLLocationUpdate.liveUpdates()
                {
                    guard !Task.isCancelled else
                    {
                        break
                    }

                    lastUpdate = update

                    if let location = update.location
                    {
                        lastLocation = location
                        isStationary = update.stationary
                        count += 1
                        logger.info("Location \(count): \(lastLocation)")
                    }

                    if update.insufficientlyInUse
                    {
                        let notification = UNNotificationRequest(
                            identifier: "com.example.mynotification",
                            content: notificationContent,
                            trigger: nil
                        )
                        try await notificationCenter.add(notification)
                    }
                }
            }
            catch is CancellationError
            {
                logger.info("Location updates cancelled")
            }
            catch
            {
                logger.error("Could not run location updates: \(error.localizedDescription)")
            }
        }
    }

    func stopLocationUpdates()
    {
        logger.info("Stopping location updates")
        locationUpdatesTask?.cancel()
        locationUpdatesTask = nil
    }
}
