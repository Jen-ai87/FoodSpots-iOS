import SwiftUI
import PhotosUI

struct AddRestaurantView: View {
    @EnvironmentObject var viewModel: RestaurantViewModel

    @State private var name: String = ""
    @State private var description: String = ""
    @State private var address: String = ""
    @State private var selectedCuisine: String = ""
    @State private var rating: Double = 3.0
    @State private var latitudeText: String = ""
    @State private var longitudeText: String = ""
    @State private var showSuccess = false
    @State private var showError = false
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var selectedImage: UIImage?

    private let cuisines = Restaurant.filterCuisineTypes

    var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty && !selectedCuisine.isEmpty
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.foodBackground.ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 0) {
                        headerSection
                        formContent
                    }
                }
            }
            .navigationBarHidden(true)
            .alert("Restaurant Added!", isPresented: $showSuccess) {
                Button("OK") { resetForm() }
            } message: {
                Text("\(name) has been added to FoodSpots.")
            }
            .alert("Please fill in required fields.", isPresented: $showError) {
                Button("OK") {}
            }
        }
    }

    
    private var headerSection: some View {
        HStack(spacing: 0) {
            Text("Add ")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            Text("Restaurant")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.foodOrange)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .padding(.bottom, 24)
    }

    
    private var formContent: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            PhotosPicker(selection: $selectedPhoto, matching: .images, photoLibrary: .shared()) {
                photoPlaceholder
            }
            .onChange(of: selectedPhoto) { _, newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self),
                       let image = UIImage(data: data) {
                        selectedImage = image
                    }
                }
            }

            
            formField(label: "Restaurant Name *") {
                TextField("Enter restaurant name", text: $name)
                    .padding(14)
                    .background(Color.white)
                    .cornerRadius(12)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.2), lineWidth: 1))
            }

            
            formField(label: "Description") {
                ZStack(alignment: .topLeading) {
                    if description.isEmpty {
                        Text("Describe the restaurant...")
                            .foregroundColor(Color(uiColor: .placeholderText))
                            .padding(14)
                    }
                    TextEditor(text: $description)
                        .frame(minHeight: 90)
                        .padding(10)
                        .scrollContentBackground(.hidden)
                }
                .background(Color.white)
                .cornerRadius(12)
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.2), lineWidth: 1))
            }

            
            formField(label: "Cuisine Type *") {
                cuisineSelector
            }

            
            formField(label: "Address") {
                TextField("Enter address", text: $address)
                    .padding(14)
                    .background(Color.white)
                    .cornerRadius(12)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.2), lineWidth: 1))
            }

            
            HStack(spacing: 12) {
                formField(label: "Latitude") {
                    TextField("43.6532", text: $latitudeText)
                        .keyboardType(.decimalPad)
                        .padding(14)
                        .background(Color.white)
                        .cornerRadius(12)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.2), lineWidth: 1))
                }
                formField(label: "Longitude") {
                    TextField("-79.3832", text: $longitudeText)
                        .keyboardType(.decimalPad)
                        .padding(14)
                        .background(Color.white)
                        .cornerRadius(12)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.2), lineWidth: 1))
                }
            }

            
            formField(label: "Rating: \(String(format: "%.1f", rating))") {
                HStack {
                    ForEach(1...5, id: \.self) { star in
                        Image(systemName: Double(star) <= rating ? "star.fill" : "star")
                            .foregroundColor(.foodOrange)
                            .font(.title2)
                            .onTapGesture { rating = Double(star) }
                    }
                    Spacer()
                    Text(String(format: "%.1f", rating))
                        .font(.headline)
                        .foregroundColor(.foodOrange)
                }
                .padding(.vertical, 4)

                Slider(value: $rating, in: 1...5, step: 0.1)
                    .tint(.foodOrange)
            }

            
            Button(action: saveRestaurant) {
                HStack {
                    Image(systemName: "checkmark")
                    Text("Save Restaurant")
                        .fontWeight(.semibold)
                }
                .foregroundColor(isFormValid ? .white : Color.white.opacity(0.6))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(isFormValid ? Color.foodOrange : Color.gray)
                .cornerRadius(14)
            }
            .disabled(!isFormValid)
            .padding(.bottom, 30)
        }
        .padding(.horizontal, 20)
    }

    
    private var photoPlaceholder: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color.gray.opacity(0.3), style: StrokeStyle(lineWidth: 1.5, dash: [6]))
                )

            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .frame(height: 140)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .overlay(alignment: .bottomTrailing) {
                        Image(systemName: "pencil.circle.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                            .shadow(radius: 3)
                            .padding(8)
                    }
            } else {
                VStack(spacing: 8) {
                    Image(systemName: "camera.fill")
                        .font(.system(size: 32))
                        .foregroundColor(.secondary)
                    Text("Add Photo")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                    Text("Tap to upload")
                        .font(.caption)
                        .foregroundColor(Color.secondary.opacity(0.7))
                }
            }
        }
        .frame(height: 140)
    }

    
    private var cuisineSelector: some View {
        let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
        return LazyVGrid(columns: columns, spacing: 10) {
            ForEach(cuisines, id: \.self) { cuisine in
                Button(action: { selectedCuisine = cuisine }) {
                    Text(cuisine)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(selectedCuisine == cuisine ? Color.foodOrange : Color.white)
                        .foregroundColor(selectedCuisine == cuisine ? .white : .primary)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(selectedCuisine == cuisine ? Color.foodOrange : Color.gray.opacity(0.2), lineWidth: 1)
                        )
                }
            }
        }
    }

    
    @ViewBuilder
    private func formField<Content: View>(label: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.primary)
            content()
        }
    }

    private func saveRestaurant() {
        guard isFormValid else { showError = true; return }
        let lat = Double(latitudeText) ?? viewModel.defaultLocation.coordinate.latitude
        let lon = Double(longitudeText) ?? viewModel.defaultLocation.coordinate.longitude

        let newRestaurant = Restaurant(
            id: 0,
            name: name.trimmingCharacters(in: .whitespaces),
            cuisineType: selectedCuisine,
            restaurantDescription: description,
            address: address.isEmpty ? "Toronto, ON" : address,
            latitude: lat,
            longitude: lon,
            rating: rating,
            isFavorite: false,
            imageName: ""
        )
        viewModel.addRestaurant(newRestaurant)
        showSuccess = true
    }

    private func resetForm() {
        name = ""
        description = ""
        address = ""
        selectedCuisine = ""
        rating = 3.0
        latitudeText = ""
        longitudeText = ""
        selectedPhoto = nil
        selectedImage = nil
    }
}
