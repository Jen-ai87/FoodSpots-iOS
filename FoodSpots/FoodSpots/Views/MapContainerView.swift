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

            favoritesChip
                .padding(.top, 56)
                .padding(.leading, 16)

            mapControls
                .padding(.top, 56)
                .padding(.trailing, 16)
                .frame(maxWidth: .infinity, alignment: .trailing)
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

    private var favoritesChip: some View {
        HStack(spacing: 8) {
            Image(systemName: "mappin.circle.fill")
                .foregroundColor(.foodOrange)
                .font(.subheadline)
            VStack(alignment: .leading, spacing: 0) {
                Text("Your Favorites")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                Text("\(viewModel.favorites.count) saved")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.12), radius: 6, x: 0, y: 2)
    }

    private var mapControls: some View {
        VStack(spacing: 8) {
            mapControlButton(icon: "square.3.layers.3d") {}
            mapControlButton(icon: "plus") { zoomIn() }
            mapControlButton(icon: "minus") { zoomOut() }
            Spacer().frame(height: 8)
            mapControlButton(icon: isFollowingUser ? "location.fill" : "location", isActive: isFollowingUser) {
                if isFollowingUser {
                    resetToRestaurants()
                } else {
                    centerOnUser()
                }
            }
        }
    }

    private func mapControlButton(icon: String, isActive: Bool = false, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(isActive ? .white : .primary)
                .frame(width: 40, height: 40)
                .background(isActive ? Color.foodOrange : Color.white)
                .cornerRadius(10)
                .shadow(color: .black.opacity(0.12), radius: 4, x: 0, y: 2)
        }
    }

    private func zoomIn() {
        zoomMeters = max(500, zoomMeters * 0.5)
        position = .region(MKCoordinateRegion(
            center: mapCenter,
            latitudinalMeters: zoomMeters,
            longitudinalMeters: zoomMeters
        ))
    }

    private func zoomOut() {
        zoomMeters = min(50000, zoomMeters * 2)
        position = .region(MKCoordinateRegion(
            center: mapCenter,
            latitudinalMeters: zoomMeters,
            longitudinalMeters: zoomMeters
        ))
    }

    private func centerOnUser() {
        mapCenter = viewModel.effectiveLocation.coordinate
        position = .region(MKCoordinateRegion(
            center: mapCenter,
            latitudinalMeters: zoomMeters,
            longitudinalMeters: zoomMeters
        ))
        isFollowingUser = true
    }

    private func resetToRestaurants() {
        mapCenter = CLLocationCoordinate2D(latitude: 43.6532, longitude: -79.3832)
        zoomMeters = 4000
        position = .region(MKCoordinateRegion(
            center: mapCenter,
            latitudinalMeters: zoomMeters,
            longitudinalMeters: zoomMeters
        ))
        isFollowingUser = false
    }
}
