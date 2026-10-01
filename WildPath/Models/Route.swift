import Foundation
import SwiftData

@Model
final class Route
{
    @Attribute(.unique) var id: UUID
    var name: String
    var startedAt: Date
    var endedAt: Date?
    var distance: Double
    var duration: TimeInterval

    @Relationship(deleteRule: .cascade, inverse: \RoutePoint.route)
    var points: [RoutePoint]

    init(
        id: UUID = UUID(),
        name: String = "",
        startedAt: Date = .now,
        endedAt: Date? = nil,
        distance: Double = 0,
        duration: TimeInterval = 0,
        points: [RoutePoint] = []
    )
    {
        self.id = id
        self.name = name
        self.startedAt = startedAt
        self.endedAt = endedAt
        self.distance = distance
        self.duration = duration
        self.points = points
    }
}
