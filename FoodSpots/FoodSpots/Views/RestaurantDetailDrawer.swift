import SwiftUI
import MapKit

struct RestaurantDetailDrawer: View {
    let restaurant: Restaurant
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var viewModel: RestaurantViewModel

    var distanceText: String {
        String(format: "%.1f mi away", restaurant.distance(from: viewModel.effectiveLocation))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            Capsule()
                .fill(Color.secondary.opacity(0.3))
                .frame(width: 36, height: 4)
                .frame(maxWidth: .infinity)
                .padding(.top, 10)
                .padding(.bottom, 16)

            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(restaurant.name)
                        .font(.title2)
                        .fontWeight(.bold)
                    Text(restaurant.cuisineType)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Spacer()
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 14)

            Divider().padding(.horizontal, 20)

            HStack(spacing: 16) {
                HStack(spacing: 5) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.foodOrange)
                        .font(.subheadline)
                    Text(String(format: "%.1f", restaurant.rating))
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.foodOrange)
                }
                Text("•")
                    .foregroundColor(.secondary)
                Text(distanceText)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 20)
            .padding(.top, 14)
            .padding(.bottom, 14)
        }
        .background(Color.white)
    }
}
