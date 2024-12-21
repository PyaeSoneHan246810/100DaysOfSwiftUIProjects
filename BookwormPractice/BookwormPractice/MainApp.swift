import SwiftData
import SwiftUI

@main
struct MainApp: App {
    var body: some Scene {
        WindowGroup {
            BookListScreenView()
        }.modelContainer(for: Book.self)
    }
}
