import Foundation
import CoreLocation
import Combine

class RestaurantViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var restaurants: [Restaurant] = []
    @Published var selectedCuisine: String = "All"
    @Published var minimumRating: Double = 0
    @Published var searchText: String = ""
    @Published var userLocation: CLLocation?
    @Published var locationStatus: CLAuthorizationStatus = .notDetermined
    
    private let locationManager = CLLocationManager()
    private let db = DatabaseManager.shared
    
    let defaultLocation = CLLocation(latitude: 43.6532, longitude: -79.3832)
    
    var effectiveLocation: CLLocation { userLocation ?? defaultLocation }
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        loadRestaurants()
    }
    
    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func loadRestaurants() {
        restaurants = db.fetchAll()
    }
    
    var filteredRestaurants: [Restaurant] {
        var list = restaurants

        if selectedCuisine != "All" {
            list = list.filter { $0.cuisineType == selectedCuisine }
        }
        if minimumRating > 0 {
            list = list.filter { $0.rating >= minimumRating }
        }
        if !searchText.isEmpty {
            list = list.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.cuisineType.localizedCaseInsensitiveContains(searchText)
            }
        }

        let loc = effectiveLocation
        return list.sorted { $0.distance(from: loc) < $1.distance(from: loc) }
    }
    
    var favorites: [Restaurant] {
        restaurants.filter { $0.isFavorite }.sorted {
            $0.distance(from: effectiveLocation) < $1.distance(from: effectiveLocation)
        }
    }
    
    func toggleFavorite(_ restaurant: Restaurant) {
        db.toggleFavorite(id: restaurant.id, newValue: !restaurant.isFavorite)
        loadRestaurants()
    }

    func addRestaurant(_ restaurant: Restaurant) {
        _ = db.insert(restaurant)
        loadRestaurants()
    }


}
