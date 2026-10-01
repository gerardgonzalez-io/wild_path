import CoreLocation
import Observation
import OSLog
import SwiftUI
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

    @ObservationIgnored
    @AppStorage("liveUpdatesStarted")
    private var storedUpdatesStarted = false

    @ObservationIgnored
    @AppStorage("BGActivitySessionStarted")
    private var storedBackgroundUpdates = false

    private(set) var updatesStarted = false
    private(set) var backgroundUpdates = false

    private(set) var lastUpdate: CLLocationUpdate?
    private(set) var lastLocation = CLLocation()
    private(set) var count = 0
    private(set) var isStationary = false

#if os(iOS) || os(watchOS)
    @ObservationIgnored
    private var backgroundActivitySession: CLBackgroundActivitySession?
#endif

    @ObservationIgnored
    private var locationUpdatesTask: Task<Void, Never>?

    private init()
    {
        let content = UNMutableNotificationContent()
        content.title = "Location updates inactive"
        content.body = "Can't receive location updates while not in the foreground"
        notificationContent = content
        updatesStarted = storedUpdatesStarted
        backgroundUpdates = storedBackgroundUpdates
        
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

        if updatesStarted
        {
            startLocationUpdates()
        }

        if backgroundUpdates
        {
            setBackgroundUpdatesEnabled(true)
        }
    }

    func setLocationUpdatesEnabled(_ isEnabled: Bool)
    {
        updatesStarted = isEnabled
        storedUpdatesStarted = isEnabled

        if isEnabled
        {
            startLocationUpdates()
        }
        else
        {
            stopLocationUpdates()
        }
    }

    func setBackgroundUpdatesEnabled(_ isEnabled: Bool)
    {
        backgroundUpdates = isEnabled
        storedBackgroundUpdates = isEnabled

#if os(iOS) || os(watchOS)
        if isEnabled
        {
            if backgroundActivitySession == nil
            {
                backgroundActivitySession = CLBackgroundActivitySession()
            }
        }
        else
        {
            backgroundActivitySession?.invalidate()
            backgroundActivitySession = nil
        }
#endif
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
                    guard !Task.isCancelled, updatesStarted else
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
        setBackgroundUpdatesEnabled(false)
    }
}
