import SwiftData
import SwiftUI

@main
struct HotProspectsApp: App {
    var body: some Scene {
        WindowGroup {
            MainRootView()
        }.modelContainer(for: Prospect.self)
    }
}
