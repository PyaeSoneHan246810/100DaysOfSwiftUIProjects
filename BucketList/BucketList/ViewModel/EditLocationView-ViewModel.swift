import Foundation

extension EditLocationView {
    @Observable
    class ViewModel {
        var name: String
        var description: String
        
        private(set) var location: Location
        private(set) var dataState: DataState = DataState.loading
        private(set) var pages: [Page] = []
        
        init(location: Location) {
            self.name = location.name
            self.description = location.description
            self.location = location
        }
        
        var editedLocation: Location {
            return Location(
                id: UUID(),
                name: name,
                description: description,
                latitude: location.latitude,
                longitude: location.longitude
            )
        }
        
        func fetchNearbyPlaces() async {
            dataState = .loading
            let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(location.latitude)%7C\(location.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"
            guard let url = URL(string: urlString) else {
                print("Invalid URL.")
                dataState = .failure
                return
            }
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let result = try JSONDecoder().decode(Result.self, from: data)
                pages = result.query.pages.values.sorted()
                dataState = .success
            } catch {
                print(error.localizedDescription)
                dataState = .failure
            }
        }
    }
}
