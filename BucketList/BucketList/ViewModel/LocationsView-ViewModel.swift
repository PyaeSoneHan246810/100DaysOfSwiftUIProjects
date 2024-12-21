import Foundation
import MapKit

extension LocationsView {
    @Observable
    class ViewModel {
        var selectedLocation: Location?
        
        private(set) var locations: [Location]
        
        let savedPath = URL.documentsDirectory.appending(path: "SavedPlaces")
        
        init() {
            do {
                let data = try Data(contentsOf: savedPath)
                locations = try JSONDecoder().decode([Location].self, from: data)
            } catch {
                locations = []
                print(error.localizedDescription)
            }
        }
        
        private func saveLocations() {
            do {
                let data = try JSONEncoder().encode(locations)
                try data.write(to: savedPath, options: [.atomic, .completeFileProtection])
            } catch {
                print(error.localizedDescription)
            }
        }
        
        func addLocation(at coordinate: CLLocationCoordinate2D) {
            let location = Location(
                id: UUID(),
                name: "",
                description: "",
                latitude: coordinate.latitude,
                longitude: coordinate.longitude
            )
            locations.append(location)
            selectedLocation = location
            saveLocations()
        }
        
        func editLocation(with editedLocation: Location) {
            guard let selectedLocation else { return }
            if let index = locations.firstIndex(of: selectedLocation) {
                locations[index] = editedLocation
                saveLocations()
            }
        }
     }
}
