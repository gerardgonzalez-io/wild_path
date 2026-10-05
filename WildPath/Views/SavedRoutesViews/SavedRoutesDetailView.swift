import MapKit
import SwiftData
import SwiftUI

struct SavedRoutesDetailView: View
{
    @Bindable var route: Route

    var body: some View
    {
        VStack(spacing: 0)
        {
            routeMap
                .frame(maxHeight: .infinity)
                .ignoresSafeArea(edges: .top)

            VStack(alignment: .leading, spacing: 20)
            {
                TextField("Route name", text: $route.name)
                    .font(.title.bold())
                    .textFieldStyle(.plain)
                    .accessibilityLabel("Route name")

                MetricView(
                    distance: route.distance,
                    duration: route.duration,
                    pointCount: route.points.count
                )
                .padding(.horizontal, -16)

                VStack(spacing: 12)
                {
                    NavigationLink(value: AppDestination.arNavigation(route))
                    {
                        Label("Start AR Navigation", systemImage: "viewfinder")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.regular)

                    NavigationLink(value: AppDestination.mapNavigator(route))
                    {
                        Label("Open Map Navigator", systemImage: "map")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.regular)
                }
            }
            .padding(.horizontal)
            .padding(.top, 20)
            .padding(.bottom)
            .background(.background)
        }
        .navigationTitle("Route Preview")
        .navigationBarTitleDisplayMode(.large)
        .toolbarBackground(.hidden, for: .navigationBar)
    }

    @ViewBuilder
    private var routeMap: some View
    {
        if coordinates.isEmpty
        {
            Map()
        }
        else
        {
            Map(initialPosition: .region(mapRegion))
            {
                MapPolyline(coordinates: coordinates)
                    .stroke(.blue, lineWidth: 6)

                if let startCoordinate = coordinates.first
                {
                    Marker("Start", systemImage: "figure.walk", coordinate: startCoordinate)
                        .tint(.green)
                }

                if let endCoordinate = coordinates.last
                {
                    Marker("Finish", systemImage: "flag.checkered", coordinate: endCoordinate)
                        .tint(.red)
                }
            }
        }
    }

    private var coordinates: [CLLocationCoordinate2D]
    {
        route.points
            .sorted { $0.timestamp < $1.timestamp }
            .map
            {
                CLLocationCoordinate2D(
                    latitude: $0.latitude,
                    longitude: $0.longitude
                )
            }
    }

    private var mapRegion: MKCoordinateRegion
    {
        let latitudes = coordinates.map(\.latitude)
        let longitudes = coordinates.map(\.longitude)
        let minimumLatitude = latitudes.min() ?? 0
        let maximumLatitude = latitudes.max() ?? 0
        let minimumLongitude = longitudes.min() ?? 0
        let maximumLongitude = longitudes.max() ?? 0

        return MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: (minimumLatitude + maximumLatitude) / 2,
                longitude: (minimumLongitude + maximumLongitude) / 2
            ),
            span: MKCoordinateSpan(
                latitudeDelta: max((maximumLatitude - minimumLatitude) * 1.6, 0.01),
                longitudeDelta: max((maximumLongitude - minimumLongitude) * 1.6, 0.01)
            )
        )
    }
}

#Preview
{
    NavigationStack
    {
        SavedRoutesDetailView(route: .sample)
    }
    .sampleDataContainer()
}
