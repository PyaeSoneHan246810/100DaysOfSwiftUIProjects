import SwiftData
import SwiftUI

struct UserListScreenView: View {
    @Environment(\.modelContext) var modelContext
    @Query private var users: [User]
    @State private var isLoading: Bool = false
    var body: some View {
        NavigationStack {
            ZStack(alignment: .center) {
                if isLoading {
                    ProgressView()
                } else {
                    UsersListComponentView(
                        users: users
                    )
                }
            }.preferredColorScheme(.dark).navigationTitle("FriendFace")
                .navigationBarTitleDisplayMode(.inline)
                .task {
                    await fetchUsers()
                }
        }
    }
    private func fetchUsers() async {
        guard users.isEmpty else {
            print("Already fetched users.")
            return
        }
        guard let url = URL(string: Constants.url) else {
            print("Invalid Data Source..")
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        isLoading = true
        do {
            let (data, _) = try await URLSession.shared.data(for: urlRequest)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let decodedUsers = try decoder.decode([User].self, from: data)
            decodedUsers.forEach { user in
                modelContext.insert(user)
            }
            isLoading = false
        } catch {
            print(error.localizedDescription)
            isLoading = false
        }
    }
}

#Preview {
    UserListScreenView()
}
