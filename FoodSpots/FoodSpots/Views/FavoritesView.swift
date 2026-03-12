import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var viewModel: RestaurantViewModel
    @State private var selectedRestaurant: Restaurant?

    var body: some View {
        NavigationStack {
            ZStack {
                Color.foodBackground.ignoresSafeArea()

                if viewModel.favorites.isEmpty {
                    Text("No favorites yet")
                } else {
                    content
                }
            }
            .navigationBarHidden(true)
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
}
