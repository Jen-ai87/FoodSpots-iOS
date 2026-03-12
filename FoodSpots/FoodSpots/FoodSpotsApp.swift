import SwiftUI

@main
struct FoodSpotsApp: App {
    @StateObject private var viewModel = RestaurantViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(viewModel).onAppear { viewModel.requestLocation() }
        }
    }
}
