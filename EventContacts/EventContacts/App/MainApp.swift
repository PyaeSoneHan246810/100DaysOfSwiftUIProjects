import SwiftUI
import SwiftData

@main
struct MainApp: App {
    var body: some Scene {
        WindowGroup {
            MainRootView()
        }.modelContainer(for: Contact.self)
    }
}
