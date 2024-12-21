import SwiftData
import SwiftUI

struct ExpenseListComponentView: View {
    @Environment(\.modelContext) var modelContext
    @Query var expenses: [Expense]
    var body: some View {
        List {
            ForEach(expenses) { expense in
                NavigationLink(value: expense) {
                    ExpenseItemComponentView(
                        expense: expense
                    )
                }
            }.onDelete { indexSet in
                indexSet.forEach { index in
                    let expense = expenses[index]
                    modelContext.delete(expense)
                }
            }
        }
    }
    init(filteredCategory: String? = nil, sortOrder: [SortDescriptor<Expense>]) {
        let allCategoryOption = ExpenseCategory.all.rawValue
        _expenses = Query(
            filter: #Predicate<Expense> { expense in
                if filteredCategory != allCategoryOption {
                    return expense.category == filteredCategory!
                } else {
                    return true
                }
            },
            sort: sortOrder
        )
    }
}
