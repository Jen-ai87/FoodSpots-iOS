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
    @ViewBuilder
    private var cuisineGradient: some View {
        let colors = gradientColors(for: restaurant.cuisineType)
        LinearGradient(
            gradient: Gradient(colors: colors),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .cornerRadius(16, corners: [.topLeft, .topRight])
    }

    @ViewBuilder
    private var cuisineIcon: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Image(systemName: cuisineSymbol(for: restaurant.cuisineType))
                    .font(.system(size: 72))
                    .foregroundColor(.white.opacity(0.25))
                    .padding(.trailing, 12)
                    .padding(.bottom, 8)
            }
        }
    }

    private func gradientColors(for cuisine: String) -> [Color] {
        switch cuisine {
        case "Italian":   return [Color(hex: "E53935"), Color(hex: "EF9A9A")]
        case "Japanese":  return [Color(hex: "5C6BC0"), Color(hex: "9FA8DA")]
        case "Mexican":   return [Color(hex: "FB8C00"), Color(hex: "FFCC80")]
        case "American":  return [Color(hex: "F9A825"), Color(hex: "FFF176")]
        case "Chinese":   return [Color(hex: "C62828"), Color(hex: "EF9A9A")]
        case "Indian":    return [Color(hex: "EF6C00"), Color(hex: "FFCC80")]
        case "Thai":      return [Color(hex: "2E7D32"), Color(hex: "A5D6A7")]
        case "French":    return [Color(hex: "6A1B9A"), Color(hex: "CE93D8")]
        case "Korean":    return [Color(hex: "AD1457"), Color(hex: "F48FB1")]
        default:          return [Color(hex: "FF6D00"), Color(hex: "FFD180")]
        }
    }

    private func cuisineSymbol(for cuisine: String) -> String {
        switch cuisine {
        case "Italian":   return "fork.knife"
        case "Japanese":  return "fish.fill"
        case "Mexican":   return "flame.fill"
        case "American":  return "menucard.fill"
        case "Chinese":   return "takeoutbag.and.cup.and.straw.fill"
        case "Indian":    return "flame"
        case "Thai":      return "leaf.fill"
        case "French":    return "wineglass.fill"
        case "Korean":    return "flame.circle.fill"
        default:          return "fork.knife"
        }
    }


}

