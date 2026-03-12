import SwiftUI

struct HomeView: View {
    @EnvironmentObject var viewModel: RestaurantViewModel
    @State private var showSearch = false
    @State private var selectedRestaurant: Restaurant?
    private let cuisines = Restaurant.cuisineTypes
    
    var body: some View {
        
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
