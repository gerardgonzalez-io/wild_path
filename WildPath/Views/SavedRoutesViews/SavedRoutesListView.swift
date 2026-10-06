import SwiftData
import SwiftUI

struct SavedRoutesListView: View
{
    @Environment(\.modelContext) private var modelContext

    @Query(sort: \Route.startedAt, order: .reverse)
    private var routes: [Route]

    @State private var routesPendingDeletion: [Route] = []
    @State private var isShowingDeleteConfirmation = false

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
            List
            {
                ForEach(routes)
                { route in
                    NavigationLink(value: AppDestination.routeDetails(route))
                    {
                        SavedRouteRow(route: route)
                    }
                }
                .onDelete(perform: requestRouteDeletion)
            }
            .navigationTitle("Saved Routes")
            .toolbar
            {
                EditButton()
            }
            .confirmationDialog(
                "Delete Route?",
                isPresented: $isShowingDeleteConfirmation,
                titleVisibility: .visible
            )
            {
                Button("Delete", role: .destructive, action: deletePendingRoutes)
                Button("Cancel", role: .cancel) { }
            }
            message:
            {
                Text("This action cannot be undone.")
            }
        }
    }

    private func requestRouteDeletion(at offsets: IndexSet)
    {
        routesPendingDeletion = offsets.map { routes[$0] }
        isShowingDeleteConfirmation = true
    }

    private func deletePendingRoutes()
    {
        for route in routesPendingDeletion
        {
            modelContext.delete(route)
        }

        routesPendingDeletion.removeAll()
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
