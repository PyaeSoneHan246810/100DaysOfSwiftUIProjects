import MapKit
import SwiftUI

struct LocationsView: View {
    //MARK: PROPERTIES
    let initialPosition = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 21.91, longitude: 95.95),
            span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
        )
    )
    let mapStyleOptions = [
        "Standard",
        "Imagery",
        "Hybrid"
    ]
    
    //MARK: COMPUTED PROPERTIES
    var mapStyle: MapStyle {
        switch selectedMapStyleOption {
        case "Standard": return .standard
        case "Hybrid": return .hybrid
        case "Imagery": return .imagery
        default: return .standard
        }
    }
    
    //MARK: STATES
    @State private var selectedMapStyleOption = "Standard"
    
    //MARK: VIEW MODEL
    @State private var viewModel = ViewModel()
    
    //MARK: BODY VIEW
    var body: some View {
        ZStack(alignment: .topTrailing) {
            MapReader { mapProxy in
                Map(
                    initialPosition: initialPosition
                ) {
                    ForEach(viewModel.locations) { location in
                        Annotation(
                            location.name,
                            coordinate: location.coordinate
                        ) {
                            Image(systemName: "star.circle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .foregroundStyle(Color.white)
                                .background(Color.mint)
                                .clipShape(.circle)
                                .simultaneousGesture(
                                    LongPressGesture(minimumDuration: 0.5)
                                        .onEnded { _ in
                                            viewModel.selectedLocation = location
                                        }
                                )
                        }.annotationTitles(.hidden)
                    }
                }.mapStyle(mapStyle).onTapGesture { position in
                    if let coordinate = mapProxy.convert(position, from: .local) {
                        viewModel.addLocation(at: coordinate)
                    }
                }
            }
            Picker("Map Style", selection: $selectedMapStyleOption) {
                ForEach(mapStyleOptions, id: \.self) { mapStyleOption in
                    Text(mapStyleOption)
                        
                }
            }.frame(width: 120, height: 40)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.mint)
                .tint(Color.white)
                .clipShape(.rect(cornerRadius: 12.0))
                .padding()
        }.sheet(item: $viewModel.selectedLocation) { location in
            EditLocationView(
                location: location,
                onSave: { editedLocation in
                    viewModel.editLocation(with: editedLocation)
                }
            )
        }
    }
}


//MARK: PREVIEW
#Preview {
    LocationsView()
}
