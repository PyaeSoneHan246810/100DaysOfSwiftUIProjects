import SwiftUI

struct ContactInfoView: View {
    let contact: Contact
    var body: some View {
        VStack {
            if let image = contact.image {
                image
                    .resizable()
                    .scaledToFit()
                    .clipShape(.rect(cornerRadius: 12.0))
            } else {
                Image(systemName: "person.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120.0, height: 120.0)
                    .foregroundStyle(Color.mint)
            }
            VStack(spacing: 8.0) {
                Text(contact.name)
                    .font(.title.weight(.semibold))
                Text(contact.email)
                    .font(.headline.weight(.semibold))
            }
        }.frame(maxWidth: .infinity)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    ContactInfoView(
        contact: Contact.previewContact
    )
}
