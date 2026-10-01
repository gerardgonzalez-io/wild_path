import Foundation
import Observation

@MainActor
@Observable
final class RecordingViewViewModel
{
    private(set) var distance: Double = 0
    private(set) var duration: TimeInterval = 0
    private(set) var pointCount: Int = 0

    func update(using routes: [Route])
    {
        guard let currentRoute = routes.first
        else
        {
            distance = 0
            duration = 0
            pointCount = 0
            return
        }

        distance = currentRoute.distance
        duration = currentRoute.duration
        pointCount = currentRoute.points.count
    }
}
