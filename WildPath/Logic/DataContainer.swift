import SwiftData
import SwiftUI

@Observable
@MainActor
final class DataContainer
{
    static let schema = Schema([
        Route.self,
        RoutePoint.self
    ])

    let modelContainer: ModelContainer

    var context: ModelContext
    {
        modelContainer.mainContext
    }

    init(
        includeSampleData: Bool = false,
        modelConfiguration: ModelConfiguration? = nil
    )
    {
        let schema = Self.schema
        let configuration = modelConfiguration
            ?? ModelConfiguration(schema: schema, isStoredInMemoryOnly: includeSampleData)

        do
        {
            modelContainer = try ModelContainer(
                for: schema,
                configurations: [configuration]
            )

            if includeSampleData
            {
                try loadSampleData()
            }

            try finishInterruptedRoutes()
            try context.save()
        }
        catch
        {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }

    private func loadSampleData() throws
    {
        for route in Route.sampleData
        {
            context.insert(route)
        }
    }

    func finishInterruptedRoutes() throws
    {
        let descriptor = FetchDescriptor<Route>(
            predicate: #Predicate { route in
                route.endedAt == nil
            }
        )
        let interruptedRoutes = try context.fetch(descriptor)

        for route in interruptedRoutes
        {
            route.state = .finished
            route.endedAt = route.points
                .map(\.timestamp)
                .max() ?? route.startedAt
        }
    }
}

private let sampleContainer = DataContainer(includeSampleData: true)

extension View
{
    func sampleDataContainer() -> some View
    {
        environment(sampleContainer)
            .modelContainer(sampleContainer.modelContainer)
    }
}
