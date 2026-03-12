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
            
            ZStack(alignment: .topTrailing) {
                ZStack(alignment: .bottomLeading) {
                    cuisineGradient
                        .frame(height: 180)
                        .clipped()

                    cuisineIcon
                        .frame(height: 180)

                    Text(distanceText)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.black.opacity(0.55))
                        .cornerRadius(20)
                        .padding(10)
                }

                HStack(spacing: 6) {
                    if showDeleteButton {
                        Button(action: { onDeleteTap?() }) {
                            Image(systemName: "trash.fill")
                                .foregroundColor(.white)
                                .padding(8)
                                .background(Color.red)
                                .clipShape(Circle())
                        }
                    }
                    Button(action: { onFavoriteTap?() }) {
                        Image(systemName: restaurant.isFavorite ? "heart.fill" : "heart")
                            .foregroundColor(restaurant.isFavorite ? .red : .white)
                            .padding(8)
                            .background(restaurant.isFavorite ? Color.white : Color.black.opacity(0.3))
                            .clipShape(Circle())
                    }
                }
                .padding(10)
            }

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(restaurant.name)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    Spacer()
                    HStack(spacing: 3) {
                        Image(systemName: "star.fill")
                            .font(.caption)
                            .foregroundColor(.foodOrange)
                        Text(String(format: "%.1f", restaurant.rating))
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.foodOrange)
                    }
                }

                Text(restaurant.cuisineType)
                    .font(.subheadline)
                    .foregroundColor(.foodOrange)

                HStack(spacing: 4) {
                    Image(systemName: "mappin")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(restaurant.address)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
        }
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 3)
        .onTapGesture { onTap?() }
    }
    // Temporary stubs to compile; will be replaced next commit.
    private var cuisineGradient: some View {
        Color.gray
    }

    private var cuisineIcon: some View {
        Color.clear
    }


}

