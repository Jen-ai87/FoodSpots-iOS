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
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    func distance(from location: CLLocation) -> Double {
        let loc = CLLocation(latitude: latitude, longitude: longitude)
        return location.distance(from: loc) / 1609.34
    }
    
    static func == (lhs: Restaurant, rhs: Restaurant) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static let cuisineTypes = [
        "All", "Italian", "Japanese", "Mexican",
        "American", "Chinese", "Indian", "Thai", "French", "Korean"
    ]
    
    static let filterCuisineTypes = [
        "Italian", "Japanese", "Mexican",
        "American", "Chinese", "Indian", "Thai", "French", "Korean"
    ]
    
    var cuisineColor: (start: String, end: String) {
        switch cuisineType {
        case "Italian":   return ("#E53935", "#EF9A9A")
        case "Japanese":  return ("#5C6BC0", "#9FA8DA")
        case "Mexican":   return ("#FB8C00", "#FFCC80")
        case "American":  return ("#F9A825", "#FFF176")
        case "Chinese":   return ("#C62828", "#EF9A9A")
        case "Indian":    return ("#EF6C00", "#FFCC80")
        case "Thai":      return ("#2E7D32", "#A5D6A7")
        case "French":    return ("#6A1B9A", "#CE93D8")
        case "Korean":    return ("#AD1457", "#F48FB1")
        default:          return ("#FF6D00", "#FFD180")
        }
    }
}
