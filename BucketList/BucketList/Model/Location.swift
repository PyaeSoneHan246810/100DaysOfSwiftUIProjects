import MapKit
import Foundation

struct Location: Identifiable, Equatable, Codable {
    var id: UUID
    var name: String
    var description: String
    var latitude: Double
    var longitude: Double
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    static func == (lhs: Location, rhs: Location) -> Bool {
        lhs.id == rhs.id
    }
    
    #if DEBUG
    static let example = Location(
        id: UUID(),
        name: "Shwedagon Pagoda",
        description: "One of the acknowledged wonders of the world.",
        latitude: 16.79,
        longitude: 96.14
    )
    #endif
}
