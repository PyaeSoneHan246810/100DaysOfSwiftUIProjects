import Foundation
import SwiftData
import SwiftUI
import CoreLocation

@Model
class Contact {
    var id: UUID
    var name: String
    var email: String
    var locationLatitude: Double
    var locationLongitude: Double
    @Attribute(.externalStorage) var imageData: Data?
    init(name: String, email: String, locationLatitude: Double, locationLongitude: Double, image: Data? = nil) {
        self.id = UUID()
        self.name = name
        self.email = email
        self.locationLatitude = locationLatitude
        self.locationLongitude = locationLongitude
        self.imageData = image
    }
    var image: Image? {
        if let imageData {
            let uiImage = UIImage(data: imageData)
            if let uiImage {
                return Image(uiImage: uiImage)
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: locationLatitude, longitude: locationLongitude)
    }
}

extension Contact {
    #if DEBUG
    static let previewContact = Contact(
        name: "Pyae Sone Han",
        email: "pyaesonehan246810@gmail.com",
        locationLatitude: 37.3346,
        locationLongitude: 122.0090
    )
    static let previewContactList = [
        Contact(
            name: "Pyae Sone Han",
            email: "pyaesonehan246810@gmail.com",
            locationLatitude: 37.3346,
            locationLongitude: 122.0090
        ),
        Contact(
            name: "Naing Min Htet",
            email: "naingminhtet13579@gmail.com",
            locationLatitude: 37.3346,
            locationLongitude: 122.0090
        )
    ]
    #endif
}
