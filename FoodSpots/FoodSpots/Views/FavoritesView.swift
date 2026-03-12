import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var viewModel: RestaurantViewModel
    @State private var selectedRestaurant: Restaurant?

    var body: some View {
        NavigationStack {
            ZStack {
                Color.foodBackground.ignoresSafeArea()

                if viewModel.favorites.isEmpty {
                    emptyState
                } else {
                    content
                }
            }
            .navigationBarHidden(true)
            .sheet(item: $selectedRestaurant) { restaurant in
                RestaurantDetailDrawer(restaurant: restaurant)
                    .presentationDetents([.fraction(0.52)])
                    .presentationDragIndicator(.hidden)
            }
        }
    }

    private var content: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 0) {
                        Text("My ")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        Text("Favorites")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.foodOrange)
                    }
                    Text("\(viewModel.favorites.count) saved restaurant\(viewModel.favorites.count == 1 ? "" : "s")")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 20)

                LazyVStack(spacing: 16) {
                    ForEach(viewModel.favorites) { restaurant in
                        RestaurantCardView(
                            restaurant: restaurant,
                            onTap: { selectedRestaurant = restaurant },
                            onFavoriteTap: { viewModel.toggleFavorite(restaurant) },
                            showDeleteButton: true,
                            onDeleteTap: { viewModel.toggleFavorite(restaurant) }
                        )
                        .padding(.horizontal, 20)
                        .transition(.asymmetric(
                            insertion: .scale.combined(with: .opacity),
                            removal: .opacity
                        ))
                    }
                }
                .animation(.easeInOut(duration: 0.3), value: viewModel.favorites.count)
                .padding(.bottom, 20)
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 20) {
            Image(systemName: "heart.slash.fill")
                .font(.system(size: 64))
                .foregroundColor(.foodOrange.opacity(0.4))
            Text("No favorites yet")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            Text("Tap the heart icon on any restaurant to save it here.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
    }
}
