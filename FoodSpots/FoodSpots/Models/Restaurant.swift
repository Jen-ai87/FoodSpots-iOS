import Foundation
import CoreLocation

struct Restaurant: Identifiable, Codable, Hashable {
    let id: Int64
    var name: String
    var cuisineType: String
    var restaurantDescription: String
    var address: String
    var latitude: Double
    var longitude: Double
    var rating: Double
    var isFavorite: Bool
    var imageName: String
}
