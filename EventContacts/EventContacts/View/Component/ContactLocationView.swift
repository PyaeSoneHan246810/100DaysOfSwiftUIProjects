import SwiftUI
import MapKit

struct ContactLocationView: View {
    let contact: Contact
    var body: some View {
        Map(
            initialPosition: MapCameraPosition.region(MKCoordinateRegion(center: contact.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.15, longitudeDelta: 0.15)))
        ) {
            Annotation(contact.name, coordinate: contact.coordinate) {
                if let image = contact.image {
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .clipShape(.circle)
                        .overlay {
                            Circle()
                                .strokeBorder(Color.mint, lineWidth: 2)
                        }
                }
            }
        }.clipShape(.rect(cornerRadius: 12.0))
    }
}

#Preview {
    ContactLocationView(
        contact: Contact.previewContact
    )
}
