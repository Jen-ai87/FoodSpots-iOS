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
        Map(position: $position) {
            UserAnnotation()
            ForEach(viewModel.filteredRestaurants) { restaurant in
                Annotation("", coordinate: restaurant.coordinate, anchor: .bottom) {
                    pinButton(for: restaurant)
                }
            }
        }
        .mapStyle(.standard)
        .ignoresSafeArea()
    }
    private func pinButton(for restaurant: Restaurant) -> some View {
        Button(action: {
            selectedRestaurant = restaurant
        }) {
            ZStack {
                Circle()
                    .fill(Color.foodOrange)
                    .frame(width: 36, height: 36)
                    .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 2)
                Image(systemName: "fork.knife")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
            }
        }
    }

}
