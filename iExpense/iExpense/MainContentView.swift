import SwiftUI

struct MainContentView: View {
    @State private var expenses: Expenses = Expenses()
    @State private var isAddExpensePresented: Bool = false
    var personalExpenseItems: [ExpenseItem] {
        expenses.items.filter { item in
            item.type == "Personal"
        }
    }
    var businessExpenseItems: [ExpenseItem] {
        expenses.items.filter { item in
            item.type == "Business"
        }
    }
    var body: some View {
        NavigationStack {
            List {
                Section("Personal") {
                    if personalExpenseItems.isEmpty {
                        Text("Empty")
                            .font(.body)
                            .listRowSeparator(.hidden)
                    } else {
                        ForEach(personalExpenseItems) { item in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(item.name)
                                        .font(.headline.bold())
                                    Text(item.type)
                                        .font(.body.weight(.medium))
                                }
                                Spacer()
                                Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                    .foregroundStyle(item.amount <= 1000 ? .green : item.amount <= 10000 ? .blue : .red
                                    )
                            }
                        }
                        .onDelete { indexSet in
                            removeItem(at: indexSet, for: "Personal")
                        }
                        .listRowSeparator(.hidden)
                    }
                }
                Section("Business") {
                    if businessExpenseItems.isEmpty {
                        Text("Empty")
                            .font(.body)
                            .listRowSeparator(.hidden)
                    }
                    ForEach(businessExpenseItems) { item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline.bold())
                                Text(item.type)
                                    .font(.body.weight(.medium))
                            }
                            Spacer()
                            Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                .foregroundStyle(item.amount <= 1000 ? .green : item.amount <= 10000 ? .blue : .red
                                )
                        }
                    }
                    .onDelete { indexSet in
                        removeItem(at: indexSet, for: "Business")
                    }
                    .listRowSeparator(.hidden)
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .listRowSpacing(12)
            .navigationTitle("iExpense")
            .toolbar {
                Button("Add Expense", systemImage: "plus") {
                    isAddExpensePresented.toggle()
                }
                EditButton()
            }
            .sheet(isPresented: $isAddExpensePresented) {
                AddSheetContentView(
                    expenses: expenses
                )
            }
        }
    }
    private func removeItem(at indexSet: IndexSet, for type: String) {
        let chosenItem = expenses.items.filter { item in
            item.type == type
        }[indexSet.first!]
        let index = expenses.items.firstIndex { item in
            item.id == chosenItem.id
        }!
        expenses.items.remove(at: index)
    }
}

struct ExpenseItem: Identifiable, Codable {
    var id: UUID = UUID()
    let name: String
    let type: String
    let amount: Double
}

@Observable
class Expenses {
    var items: [ExpenseItem] = [ExpenseItem]() {
        didSet {
            if let encodedData = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encodedData, forKey: "items")
            }
        }
    }
    init() {
        if let encodedData = UserDefaults.standard.data(forKey: "items") {
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: encodedData) {
                self.items = decodedItems
                return
            }
        }
        items = []
    }
}

#Preview {
    MainContentView()
}
