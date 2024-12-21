import SwiftUI
import PhotosUI

struct AddContactView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var locationManager: LocationManager = .shared
    @State private var image: Image?
    @State private var photosPickerItem: PhotosPickerItem?
    @State private var imageData: Data?
    @State private var name: String = ""
    @State private var email: String = ""
    @FocusState private var isNameTextFieldFocused: Bool
    @FocusState private var isEmailTextFieldFocused: Bool
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .center, spacing: 24.0) {
                    PhotosPicker(selection: $photosPickerItem) {
                        if let image {
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 240.0, height: 240.0)
                                .clipShape(.circle)
                        } else {
                            ContentUnavailableView(
                                "No Image",
                                systemImage: "photo.badge.plus",
                                description: Text("Tap to upload the image")
                            )
                        }
                    }.frame(width: 240.0, height: 240.0)
                        .background(Color.gray.opacity(0.25))
                        .clipShape(.circle)
                        .buttonStyle(.plain)
                        .photosPickerStyle(.presentation)
                        .onChange(of: photosPickerItem) {
                            Task {
                                await loadImage()
                            }
                        }
                        .overlay {
                            if image != nil {
                                Circle()
                                    .stroke(Color.mint, lineWidth: 2.0)
                            }
                        }
                    VStack(spacing: 20.0) {
                        TextField(
                            "Name",
                            text: $name
                        ).textFieldStyle(.roundedBorder)
                            .textInputAutocapitalization(.never)
                            .keyboardType(.default)
                            .focused($isNameTextFieldFocused)
                            .onSubmit {
                                isEmailTextFieldFocused = true
                            }
                        TextField(
                            "Email",
                            text: $email
                        ).textFieldStyle(.roundedBorder)
                            .textInputAutocapitalization(.never)
                            .keyboardType(.emailAddress)
                            .focused($isEmailTextFieldFocused)
                    }.frame(maxWidth: .infinity)
                }.padding()
            }.navigationTitle("Add Contact")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Cancel") {
                            dismiss()
                        }.foregroundStyle(Color.mint)
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Add", action: addContact)
                            .foregroundStyle(Color.mint)
                    }
                }
        }
    }
    
    private func loadImage() async {
        guard let imageDataTransferred = try? await photosPickerItem?.loadTransferable(type: Data.self) else {
            return
        }
        guard let uiImage = UIImage(data: imageDataTransferred) else {
            return
        }
        imageData = imageDataTransferred
        image = Image(uiImage: uiImage)
        isNameTextFieldFocused = true
    }
    
    private func addContact() {
        guard name.isEmpty == false else {
            return
        }
        guard email.isEmpty == false else {
            return
        }
        guard let location = locationManager.lastKnownLocation else {
            return
        }
        let contact = Contact(
            name: name,
            email: email,
            locationLatitude: location.latitude,
            locationLongitude: location.longitude,
            image: imageData
        )
        modelContext.insert(contact)
        dismiss()
    }
}

#Preview {
    AddContactView()
}

