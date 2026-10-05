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

extension RoutePoint
{
    static let sample = sampleData[0]
    static let stationarySample = sampleData[1]
    static let movingSample = sampleData[2]

    static let sampleData = [
        RoutePoint(
            latitude: -33.4219,
            longitude: -70.6328,
            altitude: 610,
            horizontalAccuracy: 4,
            verticalAccuracy: 6,
            speed: 1.4,
            speedAccuracy: 0.2,
            course: 28,
            courseAccuracy: 3,
            timestamp: .now.addingTimeInterval(-172_800)
        ),
        RoutePoint(
            latitude: -33.4204,
            longitude: -70.6307,
            altitude: 626,
            horizontalAccuracy: 3,
            verticalAccuracy: 5,
            speed: 0,
            speedAccuracy: 0.2,
            course: 32,
            courseAccuracy: 4,
            timestamp: .now.addingTimeInterval(-171_000),
            isStationary: true
        ),
        RoutePoint(
            latitude: -33.4187,
            longitude: -70.6282,
            altitude: 645,
            horizontalAccuracy: 4,
            verticalAccuracy: 7,
            speed: 1.6,
            speedAccuracy: 0.3,
            course: 36,
            courseAccuracy: 4,
            timestamp: .now.addingTimeInterval(-169_200)
        )
    ]

    static let parkSampleData = [
        RoutePoint(
            latitude: -33.4014,
            longitude: -70.6004,
            altitude: 582,
            horizontalAccuracy: 5,
            verticalAccuracy: 8,
            speed: 1.7,
            speedAccuracy: 0.3,
            course: 92,
            courseAccuracy: 5,
            timestamp: .now.addingTimeInterval(-86_400)
        ),
        RoutePoint(
            latitude: -33.4012,
            longitude: -70.5968,
            altitude: 580,
            horizontalAccuracy: 4,
            verticalAccuracy: 7,
            speed: 1.8,
            speedAccuracy: 0.2,
            course: 88,
            courseAccuracy: 4,
            timestamp: .now.addingTimeInterval(-85_500)
        ),
        RoutePoint(
            latitude: -33.4016,
            longitude: -70.5934,
            altitude: 581,
            horizontalAccuracy: 5,
            verticalAccuracy: 8,
            speed: 1.6,
            speedAccuracy: 0.3,
            course: 95,
            courseAccuracy: 5,
            timestamp: .now.addingTimeInterval(-84_600)
        )
    ]

    static let activeSampleData = [
        RoutePoint(
            latitude: -33.4372,
            longitude: -70.6506,
            altitude: 567,
            horizontalAccuracy: 4,
            verticalAccuracy: 6,
            speed: 1.3,
            speedAccuracy: 0.2,
            course: 180,
            courseAccuracy: 4,
            timestamp: .now.addingTimeInterval(-1_200)
        ),
        RoutePoint(
            latitude: -33.4390,
            longitude: -70.6504,
            altitude: 566,
            horizontalAccuracy: 4,
            verticalAccuracy: 6,
            speed: 1.5,
            speedAccuracy: 0.2,
            course: 176,
            courseAccuracy: 3,
            timestamp: .now.addingTimeInterval(-600)
        ),
        RoutePoint(
            latitude: -33.4408,
            longitude: -70.6501,
            altitude: 565,
            horizontalAccuracy: 5,
            verticalAccuracy: 7,
            speed: 1.4,
            speedAccuracy: 0.3,
            course: 174,
            courseAccuracy: 4,
            timestamp: .now
        )
    ]
}
