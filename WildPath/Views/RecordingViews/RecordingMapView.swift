import MapKit
import SwiftUI

struct RecordingMapView: View
{
    let routeCoordinates: [CLLocationCoordinate2D]

    @State private var cameraPosition: MapCameraPosition = .userLocation(
        followsHeading: false,
        fallback: .automatic
    )

    var body: some View
    {
        Map(position: $cameraPosition)
        {
            UserAnnotation()

            if routeCoordinates.count > 1
            {
                MapPolyline(coordinates: routeCoordinates)
                    .stroke(.blue, style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
            }
        }
        .mapControls
        {
            MapUserLocationButton()
            MapCompass()
        }
    }
}

#Preview
{
    RecordingMapView(routeCoordinates: RoutePoint.activeSampleData.map
    {
        CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude)
    })
}
