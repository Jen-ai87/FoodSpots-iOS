import SwiftUI

struct HomeView: View {
    @EnvironmentObject var viewModel: RestaurantViewModel
    @State private var showSearch = false
    @State private var selectedRestaurant: Restaurant?
    private let cuisines = Restaurant.cuisineTypes
    
    var body: some View {
        
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 4) {
                Image(systemName: "mappin.circle.fill")
                    .foregroundColor(.foodOrange)
                    .font(.subheadline)
                Text("Toronto, ON")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            HStack(spacing: 0) {
                Text("Discover ")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                Text("Nearby")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.foodOrange)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .padding(.bottom, 12)
    }
    
    private var searchBar: some View {
        HStack(spacing: 10) {
            Button(action: { showSearch = true }) {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)
                    Text("Search restaurants...")
                        .foregroundColor(Color(uiColor: .placeholderText))
                        .font(.body)
                    Spacer()
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 2)
            }

            Button(action: { showSearch = true }) {
                Image(systemName: "slider.horizontal.3")
                    .foregroundColor(.white)
                    .font(.system(size: 17, weight: .semibold))
                    .frame(width: 48, height: 48)
                    .background(Color.foodOrange)
                    .cornerRadius(12)
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 14)
    }
    
    
    private var cuisineFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(cuisines, id: \.self) { cuisine in
                    Button(action: { viewModel.selectedCuisine = cuisine }) {
                        Text(cuisine)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(viewModel.selectedCuisine == cuisine ? Color.foodOrange : Color.white)
                            .foregroundColor(viewModel.selectedCuisine == cuisine ? .white : .primary)
                            .cornerRadius(20)
                            .shadow(color: .black.opacity(0.06), radius: 3, x: 0, y: 1)
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.bottom, 16)
    }
    
    
    //TODO: Faraz to work on RestaurantCardView
    private var restaurantList: some View {
        LazyVStack(spacing: 16) {
            ForEach(viewModel.filteredRestaurants) { restaurant in
                RestaurantCardView(
                    restaurant: restaurant,
                    onTap: { selectedRestaurant = restaurant },
                    onFavoriteTap: { viewModel.toggleFavorite(restaurant) }
                )
                .padding(.horizontal, 20)
            }
        }
        .padding(.bottom, 20)
    }
}
