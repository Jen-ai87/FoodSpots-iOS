import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: RestaurantViewModel
    @State private var selectedTab: Tab = .home
    
    enum Tab {
        case home, map, favorites, add
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: selectedTab == .home ? "house.fill" : "house")
                }
                .tag(Tab.home)

            MapContainerView()
                .tabItem {
                    Label("Map", systemImage: selectedTab == .map ? "map.fill" : "map")
                }
                .tag(Tab.map)

            FavoritesView()
                .tabItem {
                    Label("Favorites", systemImage: selectedTab == .favorites ? "heart.fill" : "heart")
                }
                .tag(Tab.favorites)

            AddRestaurantView()
                .tabItem {
                    Label("Add", systemImage: "plus")
                }
                .tag(Tab.add)
        }
    }
}

extension Color {
    static let foodOrange = Color(red: 1.0, green: 0.42, blue: 0.0)
    static let foodBackground = Color(red: 0.97, green: 0.97, blue: 0.97)
    static let cardBackground = Color.white
}
