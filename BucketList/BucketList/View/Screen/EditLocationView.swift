import SwiftUI

struct EditLocationView: View {
    //MARK: ENVIRONMENT PROPERTIES
    @Environment(\.dismiss) var dismiss
    
    //MARK: PROPERTIES
    let location: Location
    let onSave: (Location) -> Void
    
    //MARK: VIEW MODEL
    @State private var viewModel: ViewModel
    
    //MARK: INITIALIZER
    init(location: Location, onSave: @escaping (Location) -> Void) {
        self.location = location
        self.onSave = onSave
        _viewModel = State(
            initialValue: ViewModel(location: location)
        )
    }
    
    //MARK: BODY VIEW
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField(
                        "Place name",
                        text: $viewModel.name
                    )
                    TextField(
                        "Place description",
                        text: $viewModel.description,
                        axis: .vertical
                    )
                }
                Section("Nearby Places") {
                    switch viewModel.dataState {
                    case .loading:
                        LoadingView()
                    case .failure:
                        FailureView()
                    case .success:
                        NearybyPlacesView(
                            pages: viewModel.pages
                        )
                    }
                }
            }.navigationTitle("Place Details")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Cancel") {
                            dismiss()
                        }.foregroundStyle(Color.mint)
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Save") {
                            onSave(viewModel.editedLocation)
                            dismiss()
                        }.foregroundStyle(Color.mint)
                    }
                }
        }.onAppear {
            Task {
                await viewModel.fetchNearbyPlaces()
            }
        }
    }
}

//MARK: PROPERTIES
#Preview {
    EditLocationView(
        location: Location.example,
        onSave: { _ in}
    )
}
