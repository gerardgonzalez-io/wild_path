import CoreLocation
import Foundation
import Observation
import SwiftData

enum RecordingState
{
    case idle
    case recording
    case paused
    case finished
}

@MainActor
@Observable
final class RecordingViewViewModel
{
    private(set) var recordingState: RecordingState = .idle
    private(set) var distance: Double = 0
    private(set) var duration: TimeInterval = 0
    private(set) var pointCount: Int = 0
    private(set) var errorMessage: String?

    @ObservationIgnored
    private var currentRoute: Route?

    @ObservationIgnored
    private var lastRecordedLocation: CLLocation?

    @ObservationIgnored
    private var activeSegmentStartedAt: Date?

    @ObservationIgnored
    private var accumulatedDuration: TimeInterval = 0

    var hasActiveRoute: Bool
    {
        currentRoute != nil && recordingState != .idle
    }

    func startRecording(using locationsHandler: LocationsHandler, in modelContext: ModelContext)
    {
        guard recordingState == .idle
        else
        {
            return
        }

        let route = Route(startedAt: .now)
        modelContext.insert(route)

        guard save(modelContext)
        else
        {
            modelContext.rollback()
            return
        }

        currentRoute = route
        lastRecordedLocation = nil
        accumulatedDuration = 0
        activeSegmentStartedAt = route.startedAt
        recordingState = .recording
        updateDisplayedMetrics()

        locationsHandler.startLocationUpdates()
    }

    func pauseRecording(using locationsHandler: LocationsHandler, in modelContext: ModelContext)
    {
        guard recordingState == .recording
        else
        {
            return
        }

        updateDuration(at: .now)
        activeSegmentStartedAt = nil
        recordingState = .paused
        locationsHandler.stopLocationUpdates()
        save(modelContext)
    }

    func resumeRecording(using locationsHandler: LocationsHandler)
    {
        guard recordingState == .paused, currentRoute != nil
        else
        {
            return
        }

        activeSegmentStartedAt = .now
        recordingState = .recording
        locationsHandler.startLocationUpdates()
    }

    func finishRecording(
        named name: String?,
        using locationsHandler: LocationsHandler,
        in modelContext: ModelContext
    )
    {
        guard let route = currentRoute
        else
        {
            return
        }

        if recordingState == .recording
        {
            updateDuration(at: .now)
        }

        let trimmedName = name?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        route.name = trimmedName.isEmpty ? defaultName(for: route) : trimmedName
        route.endedAt = .now
        route.state = .finished

        locationsHandler.stopLocationUpdates()
        guard save(modelContext)
        else
        {
            recordingState = .paused
            activeSegmentStartedAt = nil
            return
        }

        recordingState = .finished
        currentRoute = nil
        lastRecordedLocation = nil
        activeSegmentStartedAt = nil
        accumulatedDuration = 0
        updateDisplayedMetrics(for: route)
    }

    func record(
        location: CLLocation,
        isStationary: Bool,
        using locationsHandler: LocationsHandler,
        in modelContext: ModelContext
    )
    {
        guard recordingState == .recording,
              let route = currentRoute,
              location.horizontalAccuracy >= 0,
              location.timestamp > (lastRecordedLocation?.timestamp ?? .distantPast)
        else
        {
            return
        }

        let point = RoutePoint(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude,
            altitude: location.altitude,
            horizontalAccuracy: location.horizontalAccuracy,
            verticalAccuracy: location.verticalAccuracy,
            speed: location.speed,
            speedAccuracy: location.speedAccuracy,
            course: location.course,
            courseAccuracy: location.courseAccuracy,
            timestamp: location.timestamp,
            isStationary: isStationary,
            route: route
        )

        if let lastRecordedLocation
        {
            route.distance += location.distance(from: lastRecordedLocation)
        }

        route.points.append(point)
        modelContext.insert(point)
        lastRecordedLocation = location
        updateDuration(at: location.timestamp)
        updateDisplayedMetrics()

        if !save(modelContext)
        {
            recordingState = .paused
            activeSegmentStartedAt = nil
            locationsHandler.stopLocationUpdates()
        }
    }

    func clearError()
    {
        errorMessage = nil
    }

    private func updateDuration(at date: Date)
    {
        guard let route = currentRoute, let activeSegmentStartedAt
        else
        {
            return
        }

        let segmentDuration = max(0, date.timeIntervalSince(activeSegmentStartedAt))
        route.duration = accumulatedDuration + segmentDuration

        if recordingState == .recording
        {
            accumulatedDuration = route.duration
            self.activeSegmentStartedAt = date
        }

        duration = route.duration
    }

    private func updateDisplayedMetrics(for route: Route? = nil)
    {
        guard let route = route ?? currentRoute
        else
        {
            return
        }

        distance = route.distance
        duration = route.duration
        pointCount = route.points.count
    }

    private func defaultName(for route: Route) -> String
    {
        "Route \(route.startedAt.formatted(date: .abbreviated, time: .shortened))"
    }

    @discardableResult
    private func save(_ modelContext: ModelContext) -> Bool
    {
        do
        {
            try modelContext.save()
            return true
        }
        catch
        {
            errorMessage = error.localizedDescription
            return false
        }
    }
}
