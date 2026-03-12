import SwiftUI

struct RestaurantCardView: View {
    let restaurant: Restaurant
    var onTap: (() -> Void)?
    var onFavoriteTap: (() -> Void)?
    var showDeleteButton: Bool = false
    var onDeleteTap: (() -> Void)?

    @EnvironmentObject var viewModel: RestaurantViewModel

    var distanceText: String {
        let d = restaurant.distance(from: viewModel.effectiveLocation)
        return String(format: "%.1f mi", d)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(restaurant.name)
                .font(.headline)
            Text(distanceText)
                .font(.caption)
        }
        .onTapGesture { onTap?() }
    }
}

