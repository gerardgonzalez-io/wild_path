import SwiftUI
import SwiftData

struct RecordingView: View
{
    @Query(sort: \Route.startedAt, order: .reverse) private var routes: [Route]
    @State private var viewModel = RecordingViewViewModel()

    var body: some View
    {
        VStack(spacing: 0)
        {
            RecordingMapView()
                .frame(maxHeight: .infinity)

            RecordingMetricView(
                distance: viewModel.distance,
                duration: viewModel.duration,
                pointCount: viewModel.pointCount
            )

            RecordingControlsView()
        }
        .navigationTitle("Record Route")
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: routes, initial: true)
        { viewModel.update(using: routes) }
    }
}

#Preview
{
    NavigationStack
    {
        RecordingView()
    }
    .modelContainer(for: [Route.self, RoutePoint.self], inMemory: true)
}
