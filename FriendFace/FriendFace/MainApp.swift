import SwiftData
import SwiftUI

@main
struct MainApp: App {
    var body: some Scene {
        WindowGroup {
            UserListScreenView()
        }.modelContainer(for: Friend.self)
    }
}
