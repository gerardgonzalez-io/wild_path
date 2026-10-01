#if canImport(UIKit)
import OSLog
import UIKit

final class AppDelegate: NSObject, UIApplicationDelegate
{
    private let logger = Logger(
        subsystem: "com.apple.WildPath",
        category: "AppDelegate"
    )

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool
    {
        let locationsHandler = LocationsHandler.shared

        if locationsHandler.updatesStarted
        {
            logger.info("Restarting live updates session")
            locationsHandler.startLocationUpdates()
        }

        if locationsHandler.backgroundUpdates
        {
            logger.info("Reinstantiating background activity session")
            locationsHandler.setBackgroundUpdatesEnabled(true)
        }

        return true
    }
}
#endif
