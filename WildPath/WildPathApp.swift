import SwiftData
import SwiftUI

@main
struct WildPathApp: App
{
    let dataContainer = DataContainer()

/*
#if canImport(UIKit)
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
#endif
*/
    var body: some Scene
    {
        WindowGroup
        {
            ContentView()
                .environment(dataContainer)
        }
        .modelContainer(dataContainer.modelContainer)
    }
}
