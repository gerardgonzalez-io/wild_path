import SwiftUI

struct ContentView: View
{
    private enum Destination: Hashable
    {
        case recording
        case savedRoutes
    }

    var body: some View
    {
        NavigationStack
        {
            List
            {
                Section
                {
                    NavigationLink(value: Destination.recording)
                    {
                        Label("Record Route Offline", systemImage: "record.circle")
                    }

                    NavigationLink(value: Destination.savedRoutes)
                    {
                        Label(
                            "Follow Saved Route",
                            systemImage: "arrow.triangle.turn.up.right.diamond"
                        )
                    }
                }
            }
            .navigationTitle("WildPath")
            .navigationDestination(for: Destination.self)
            { destination in
                switch destination
                {
                case .recording:
                    RecordingView()
                case .savedRoutes:
                    SavedRoutesView()
                }
            }
        }
    }
}

#Preview
{
    ContentView()
}
