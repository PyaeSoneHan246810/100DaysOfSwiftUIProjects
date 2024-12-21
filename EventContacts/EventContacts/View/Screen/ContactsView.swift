import SwiftUI
import SwiftData

struct ContactsView: View {
    @Query(
        sort: [
            SortDescriptor<Contact>(\.name),
            SortDescriptor<Contact>(\.email)
        ]
    ) private var contacts: [Contact]
    @State private var isAddContactSheetPresent: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                if contacts.isEmpty {
                    EmptyContactsView()
                } else {
                    ContactListView(
                        contacts: contacts
                    )
                }
            }.navigationTitle("Event Contacts")
                .navigationDestination(for: Contact.self) { contact in
                    ContactDetailsView(contact: contact)
                }
                .toolbar {
                    if !contacts.isEmpty {
                        ToolbarItem(placement: .topBarLeading) {
                            EditButton()
                                .foregroundStyle(Color.mint)
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            isAddContactSheetPresent = true
                        } label: {
                            Image(systemName: "plus")
                                .foregroundStyle(Color.mint)
                        }
                    }
                }
                .sheet(isPresented: $isAddContactSheetPresent) {
                    AddContactView()
                }
        }
        
    }
}

#Preview {
    ContactsView()
        .modelContainer(for: Contact.self)
}
