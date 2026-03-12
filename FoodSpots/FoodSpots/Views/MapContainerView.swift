import SwiftUI
import MapKit

struct MapContainerView: View {
    @EnvironmentObject var viewModel: RestaurantViewModel
    @State private var mapCenter = CLLocationCoordinate2D(latitude: 43.6532, longitude: -79.3832)
    @State private var zoomMeters: Double = 4000
    @State private var position: MapCameraPosition = .region(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 43.6532, longitude: -79.3832),
        latitudinalMeters: 4000,
        longitudinalMeters: 4000
    ))
    @State private var selectedRestaurant: Restaurant?
    @State private var showDrawer = false
    @State private var isFollowingUser = false

    var body: some View {
        ZStack(alignment: .topLeading) {
            mapView
        }
        .sheet(item: $selectedRestaurant) { r in
            RestaurantDetailDrawer(restaurant: r)
                .presentationDetents([.fraction(0.45)])
                .presentationDragIndicator(.hidden)
        }
        .ignoresSafeArea(edges: .top)
    }

    @ViewBuilder
    private var mapView: some View {
        Map(position: $position) { }
            .mapStyle(.standard)
            .ignoresSafeArea()
    }
}
