import SwiftUI
import SwiftData

@main
struct WildPathApp: App
{
#if canImport(UIKit)
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
#endif

    var body: some Scene
    {
        WindowGroup
        {
            ContentView()
        }
        .modelContainer(for: [Route.self, RoutePoint.self])
    }
}
