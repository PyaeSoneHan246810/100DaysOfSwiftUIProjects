import SwiftUI

struct UsersListComponentView: View {
    let users: [User]
    var body: some View {
        List(users) { user in
            NavigationLink {
                UserDetailsScreenView(user: user)
            } label: {
                UserItemComponentView(
                    user: user
                )
            }
        }
    }
}
