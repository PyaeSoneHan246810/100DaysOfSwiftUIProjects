import SwiftUI

struct ContactListView: View {
    @Environment(\.modelContext) private var modelContext
    let contacts: [Contact]
    
    var body: some View {
        List {
            ForEach(contacts) { contact in
                ContactListItemView(
                    contact: contact
                ).background(
                    NavigationLink(value: contact){}
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .opacity(0)
                )
            }.onDelete { indexSet in
                indexSet.forEach { index in
                    let contact = contacts[index]
                    modelContext.delete(contact)
                }
            }.listRowSeparator(.hidden)
        }.listStyle(.plain)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    ContactListView(
        contacts: Contact.previewContactList
    )
}
