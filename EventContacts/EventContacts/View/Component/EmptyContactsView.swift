import SwiftUI

struct EmptyContactsView: View {
    var body: some View {
        ContentUnavailableView {
            VStack(spacing: 12.0) {
                Image(systemName: "person.2.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100.0, height: 100.0)
                    .foregroundStyle(.secondary)
                Text("Empty Contacts.")
                    .foregroundStyle(.primary)
            }
        } description: {
            Text("All of your contacts will appear here.")
                .foregroundStyle(.secondary)
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    EmptyContactsView()
}
