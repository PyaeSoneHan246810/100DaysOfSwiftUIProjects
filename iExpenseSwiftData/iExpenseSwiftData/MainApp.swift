import SwiftData
import SwiftUI

@main
struct MainApp: App {
    var body: some Scene {
        WindowGroup {
            ExpenseListScreenView()
        }.modelContainer(for: Expense.self)
    }
}
