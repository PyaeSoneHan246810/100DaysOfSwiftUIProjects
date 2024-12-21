import SwiftUI

struct ContactDetailsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    let contact: Contact
    let tabs: [String] = ["Info", "Location"]
    @State private var selectedTab: String = "Info"
    
    var body: some View {
        VStack(alignment: .center, spacing: 24.0) {
            Picker("Select the tab", selection: $selectedTab) {
                ForEach(tabs, id: \.self) { tab in
                    Text(tab)
                }
            }.pickerStyle(.segmented)
            ZStack {
                if selectedTab == tabs[0] {
                    ContactInfoView(
                        contact: contact
                    )
                } else {
                    ContactLocationView(
                        contact: contact
                    )
                }
            }.frame(maxWidth: .infinity)
                .animation(.easeInOut(duration: 0.5), value: selectedTab)
            Spacer()
        }.padding()
            .navigationTitle(contact.name)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Back") {
                        dismiss()
                    }.foregroundStyle(Color.mint)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Delete") {
                        modelContext.delete(contact)
                        dismiss()
                    }.foregroundStyle(Color.red)
                }
            }
    }
    
}

#Preview {
    ContactDetailsView(
        contact: Contact.previewContact
    )
}
