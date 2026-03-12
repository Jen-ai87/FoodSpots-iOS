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
}
