import SwiftUI

struct ContactListItemView: View {
    let contact: Contact
    var body: some View {
        HStack(spacing: 12.0) {
            if let image = contact.image {
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60.0, height: 60.0)
                    .clipShape(.circle)
            } else {
                Image(systemName: "person")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60.0, height: 60.0)
                    .foregroundStyle(Color.mint)
            }
            VStack(alignment: .leading) {
                Text(contact.name)
                    .font(.headline)
                    .foregroundStyle(Color.primary)
                Text(contact.email)
                    .font(.subheadline)
                    .foregroundStyle(Color.primary.opacity(0.75))
            }.frame(maxWidth: .infinity, alignment: .leading)
        }.frame(maxWidth: .infinity)
            .padding(4)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    ContactListItemView(
        contact: Contact.previewContact
    )
}
