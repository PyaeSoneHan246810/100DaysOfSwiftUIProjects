import SwiftUI

struct UserDetailsScreenView: View {
    let user: User
    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .frame(width: 80, height: 80)
                        .foregroundStyle(user.isActive ? .green : .red)
                    Text(user.shortName)
                        .font(.subheadline)
                        .foregroundStyle(.white)
                }
                Text(user.email)
                    .font(.headline)
            }
            UserTagsComponentView(
                tags: Array(Set(user.tags)).sorted()
            )
            List {
                Section("Basic Info") {
                    Text("Name: \(user.name)")
                    Text("Age: \(user.age)")
                    Text("Company: \(user.company)")
                    Text("Email: \(user.email)")
                    Text("Address: \(user.address)")
                    Text("Registered: \(user.formattedRegisteredDate)")
                }
                Section("About") {
                    Text(user.about)
                }
                Section("Friends") {
                    ForEach(user.friends) { friend in
                        Text(friend.name)
                    }
                }
            }
        }.navigationTitle(user.name)
    }
}
