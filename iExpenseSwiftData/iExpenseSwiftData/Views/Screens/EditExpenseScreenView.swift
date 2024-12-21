import SwiftData
import SwiftUI

struct EditExpenseScreenView: View {
    @Bindable var expense: Expense
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                Picker("Category", selection: $expense.category) {
                    ForEach(ExpenseCategory.allCases.filter { category in
                        category.rawValue != ExpenseCategory.all.rawValue
                    }, id: \.self.rawValue) { category in
                        Text(category.rawValue)
                    }
                }.pickerStyle(.segmented)
                TextField("Name", text: $expense.name)
                    .textFieldStyle(.roundedBorder)
                TextField("Amount", value: $expense.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                    .textFieldStyle(.roundedBorder)
            }.padding(20)
        }.navigationTitle("Edit Expense")
    }
}

#Preview {
    EditExpenseScreenView(
        expense: Expense(name: "Test", amount: 20000.0, category: ExpenseCategory.personal.rawValue)
    )
}
