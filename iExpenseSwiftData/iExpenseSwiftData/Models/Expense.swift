import SwiftData
import Foundation

@Model
class Expense {
    var name: String
    var amount: Double
    var category: String
    var date: Date = Date.now
    init(name: String, amount: Double, category: String) {
        self.name = name
        self.amount = amount
        self.category = category
    }
}

enum ExpenseCategory: String, CaseIterable {
    case all = "All"
    case personal = "Personal"
    case business = "Business"
}
