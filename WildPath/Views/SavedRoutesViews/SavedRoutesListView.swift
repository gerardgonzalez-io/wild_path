import SwiftData
import SwiftUI

struct SavedRoutesListView: View
{
    @Query(sort: \Route.startedAt, order: .reverse)
    private var routes: [Route]

    var body: some View
    {
        if routes.isEmpty
        {
            ContentUnavailableView(
                "No Saved Routes",
                systemImage: "map",
                description: Text("Routes you finish recording will appear here.")
            )
            .navigationTitle("Saved Routes")
        }
        else
        {
            List(routes)
            { route in
                NavigationLink(value: AppDestination.routeDetails(route))
                {
                    SavedRouteRow(route: route)
                }
            }
            .navigationTitle("Saved Routes")
        }
    }
}

private struct SavedRouteRow: View
{
    let route: Route

    var body: some View
    {
        VStack(alignment: .leading, spacing: 8)
        {
            Text(route.name.isEmpty ? "Untitled Route" : route.name)
                .font(.headline)

            HStack
            {
                Label(distanceText, systemImage: "point.topleft.down.to.point.bottomright.curvepath")
                Spacer()
                Label(durationText, systemImage: "clock")
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }

    private var distanceText: String
    {
        Measurement(value: route.distance, unit: UnitLength.meters)
            .formatted(.measurement(width: .abbreviated))
    }

    private var durationText: String
    {
        Duration.seconds(route.duration)
            .formatted(.time(pattern: .hourMinuteSecond))
    }
}

#Preview
{
    NavigationStack
    {
        SavedRoutesListView()
    }
    .sampleDataContainer()
}
