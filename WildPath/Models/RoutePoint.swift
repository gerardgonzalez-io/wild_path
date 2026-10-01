import Foundation
import SwiftData

@Model
final class RoutePoint
{
    @Attribute(.unique) var id: UUID
    var latitude: Double
    var longitude: Double
    var altitude: Double
    var horizontalAccuracy: Double
    var verticalAccuracy: Double
    var speed: Double
    var speedAccuracy: Double
    var course: Double
    var courseAccuracy: Double
    var timestamp: Date
    var isStationary: Bool
    var route: Route?

    init(
        id: UUID = UUID(),
        latitude: Double,
        longitude: Double,
        altitude: Double,
        horizontalAccuracy: Double,
        verticalAccuracy: Double,
        speed: Double,
        speedAccuracy: Double,
        course: Double,
        courseAccuracy: Double,
        timestamp: Date,
        isStationary: Bool = false,
        route: Route? = nil
    )
    {
        self.id = id
        self.latitude = latitude
        self.longitude = longitude
        self.altitude = altitude
        self.horizontalAccuracy = horizontalAccuracy
        self.verticalAccuracy = verticalAccuracy
        self.speed = speed
        self.speedAccuracy = speedAccuracy
        self.course = course
        self.courseAccuracy = courseAccuracy
        self.timestamp = timestamp
        self.isStationary = isStationary
        self.route = route
    }
}
