import SwiftUI

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
    }
}
