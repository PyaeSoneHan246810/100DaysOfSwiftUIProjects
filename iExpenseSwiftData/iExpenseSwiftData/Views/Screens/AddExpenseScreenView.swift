import SwiftData
import SwiftUI

struct AddExpenseScreenView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @State private var name: String = ""
    @State private var amount: Double = 0.0
    @State private var category: String = ExpenseCategory.personal.rawValue
    @State private var isAlertPresented: Bool = false
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""
    var categoryColor: Color {
        switch category {
        case ExpenseCategory.personal.rawValue:
            return Color.indigo
        case ExpenseCategory.business.rawValue:
            return Color.teal
        default:
            return Color.primary
        }
    }
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 20) {
                    Picker("Category", selection: $category) {
                        ForEach(ExpenseCategory.allCases.filter { category in
                            category.rawValue != ExpenseCategory.all.rawValue
                        }, id: \.self.rawValue) { category in
                            Text(category.rawValue)
                        }
                    }.pickerStyle(.segmented)
                    TextField("Name", text: $name)
                        .textFieldStyle(.roundedBorder)
                    TextField("Amount", value: $amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                        .textFieldStyle(.roundedBorder)
                    
                }.padding(20)
            }.navigationTitle("Add Expense")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Save", action: addExpense)
                            .foregroundStyle(categoryColor)
                    }
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Cancel", role: .cancel) {
                            dismiss()
                        }.foregroundStyle(.secondary)
                    }
                }
                .alert(alertTitle, isPresented: $isAlertPresented) {} message : {
                    Text(alertMessage)
                }
        }
    }
    private func addExpense() {
        let name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !name.isEmpty else {
            alertTitle = "Invalid Name"
            alertMessage = "Please enter a name for your expense."
            isAlertPresented.toggle()
            return
        }
        guard amount > 0.0 else {
            alertTitle = "Invalid Amount"
            alertMessage = "Please enter a valid amount for your expense."
            isAlertPresented.toggle()
            return
        }
        let expense = Expense(name: name, amount: amount, category: category)
        modelContext.insert(expense)
        dismiss()
    }
}

#Preview {
    AddExpenseScreenView()
}
