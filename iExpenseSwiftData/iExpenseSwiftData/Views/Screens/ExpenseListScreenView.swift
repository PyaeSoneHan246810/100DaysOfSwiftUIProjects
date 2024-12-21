import SwiftData
import SwiftUI

struct ExpenseListScreenView: View {
    @State private var isSheetPresented: Bool = false
    @State private var filteredCategory: String = ExpenseCategory.all.rawValue
    @State private var sortOrder: [SortDescriptor<Expense>] = [
        SortDescriptor(\.name),
        SortDescriptor(\.amount),
    ]
    var body: some View {
        NavigationStack {
            ExpenseListComponentView(
                filteredCategory: filteredCategory,
                sortOrder: sortOrder
            ).navigationTitle("iExpense")
                .navigationDestination(for: Expense.self) { expense in
                    EditExpenseScreenView(expense: expense)
                }
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        EditButton()
                    }
                    ToolbarItem(placement: .primaryAction) {
                        Menu("Sort by") {
                            Picker("Sort Expenses", selection: $sortOrder) {
                                Text("Name").tag(
                                    [
                                        SortDescriptor<Expense>(\.name),
                                        SortDescriptor<Expense>(\.amount, order: .reverse),
                                    ]
                                )
                                Text("Amount").tag(
                                    [
                                        SortDescriptor<Expense>(\.amount, order: .reverse),
                                        SortDescriptor<Expense>(\.name),
                                    ]
                                )
                            }
                        }
                    }
                    ToolbarItem(placement: .primaryAction) {
                        Menu("Filter by") {
                            Picker("Filter Expenses", selection: $filteredCategory) {
                                ForEach(ExpenseCategory.allCases, id: \.self.rawValue) { category in
                                    Text(category.rawValue)
                                        
                                }
                            }
                        }
                    }
                    ToolbarItem(placement: .primaryAction) {
                        Button("Add") {
                            isSheetPresented.toggle()
                        }
                    }
                }
                .sheet(isPresented: $isSheetPresented) {
                    AddExpenseScreenView()
                }
        }
    }
}

#Preview {
    ExpenseListScreenView()
}
