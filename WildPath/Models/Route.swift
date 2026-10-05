import Foundation
import SwiftData

enum RouteState: String, Codable
{
    case recording
    case finished
}

@Model
final class Route
{
    @Attribute(.unique) var id: UUID
    var name: String
    var startedAt: Date
    var endedAt: Date?
    var state: RouteState = RouteState.recording
    var distance: Double
    var duration: TimeInterval

    @Relationship(deleteRule: .cascade, inverse: \RoutePoint.route)
    var points: [RoutePoint]

    init(
        id: UUID = UUID(),
        name: String = "",
        startedAt: Date = .now,
        endedAt: Date? = nil,
        state: RouteState? = nil,
        distance: Double = 0,
        duration: TimeInterval = 0,
        points: [RoutePoint] = []
    )
    {
        self.id = id
        self.name = name
        self.startedAt = startedAt
        self.endedAt = endedAt
        self.state = state ?? (endedAt == nil ? .recording : .finished)
        self.distance = distance
        self.duration = duration
        self.points = points
    }
}

extension Route
{
    static let sample = sampleData[0]
    static let completedRouteSample = sampleData[1]
    static let activeRouteSample = sampleData[2]

    static let sampleData = [
        Route(
            name: "Cerro San Cristóbal",
            startedAt: .now.addingTimeInterval(-172_800),
            endedAt: .now.addingTimeInterval(-169_200),
            distance: 5_240,
            duration: 3_600,
            points: RoutePoint.sampleData
        ),
        Route(
            name: "Parque Bicentenario",
            startedAt: .now.addingTimeInterval(-86_400),
            endedAt: .now.addingTimeInterval(-84_600),
            distance: 3_180,
            duration: 1_800,
            points: RoutePoint.parkSampleData
        ),
        Route(
            name: "Morning Walk",
            startedAt: .now.addingTimeInterval(-1_200),
            distance: 1_350,
            duration: 1_200,
            points: RoutePoint.activeSampleData
        )
    ]
}
