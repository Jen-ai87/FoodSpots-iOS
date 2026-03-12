import SwiftUI

struct SearchFilterView: View {
    @EnvironmentObject var viewModel: RestaurantViewModel
    @Environment(\.dismiss) private var dismiss

    private let ratingOptions: [(label: String, value: Double)] = [
        ("Any", 0), ("3+", 3), ("3.5+", 3.5), ("4+", 4), ("4.5+", 4.5)
    ]
    private let cuisines = Restaurant.filterCuisineTypes

    var body: some View {
        ZStack {
            Color.foodBackground.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {

                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.secondary)
                        TextField("Search by name or cuisine...", text: $viewModel.searchText)
                            .font(.body)
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 13)
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 2)
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 24)

                    sectionHeader("Minimum Rating")
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(ratingOptions, id: \.value) { option in
                                Button(action: { viewModel.minimumRating = option.value }) {
                                    HStack(spacing: 4) {
                                        if option.value > 0 {
                                            Image(systemName: "star.fill")
                                                .font(.caption2)
                                        }
                                        Text(option.label)
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(viewModel.minimumRating == option.value ? Color.foodOrange : Color.white)
                                    .foregroundColor(viewModel.minimumRating == option.value ? .white : .primary)
                                    .cornerRadius(20)
                                    .shadow(color: .black.opacity(0.06), radius: 3, x: 0, y: 1)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.bottom, 24)
                }
            }
        }
        .navigationTitle("Search & Filter")
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden(false)
        .onDisappear {
            // optional: reset filters later
        }
    }

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.headline)
            .fontWeight(.semibold)
            .padding(.horizontal, 20)
            .padding(.bottom, 12)
    }
}
