import SwiftUI

enum AppDestination: Hashable
{
    case recording
    case savedRoutes
    case routeDetails(Route)
    case arNavigation(Route)
    case mapNavigator(Route)
}

struct ContentView: View
{
    var body: some View
    {
        NavigationStack
        {
            List
            {
                Section
                {
                    NavigationLink(value: AppDestination.recording)
                    {
                        Label("Record Route Offline", systemImage: "record.circle")
                    }

                    NavigationLink(value: AppDestination.savedRoutes)
                    {
                        Label(
                            "Follow Saved Route",
                            systemImage: "arrow.triangle.turn.up.right.diamond"
                        )
                    }
                }
            }
            .navigationTitle("WildPath")
            .navigationDestination(for: AppDestination.self)
            { destination in
                switch destination
                {
                case .recording:
                    RecordingView()
                case .savedRoutes:
                    SavedRoutesView()
                case .routeDetails(let route):
                    SavedRoutesDetailView(route: route)
                case .arNavigation:
                    EmptyView()
                case .mapNavigator:
                    EmptyView()
                }
            }
        }
    }
}

#Preview
{
    ContentView()
}
