import SwiftUI

struct EditProspectView: View {
    @Bindable var prospect: Prospect
    var body: some View {
        VStack(spacing: 20.0) {
            TextField("Name", text: $prospect.name)
                .textFieldStyle(.roundedBorder)
                .textContentType(.name)
                .keyboardType(.default)
            TextField("Email Address", text: $prospect.emailAddress)
                .textFieldStyle(.roundedBorder)
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
            Spacer()
        }.padding().navigationTitle("Edit Prospect")
    }
}

#Preview {
    EditProspectView(
        prospect: Prospect.previewProspect
    )
}
