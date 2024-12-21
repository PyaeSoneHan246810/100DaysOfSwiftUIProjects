import SwiftUI

struct MainContentView: View {
    @State private var checkAmount = 0.0
    @State private var numberOfPeople = 2
    @State private var tipPercentage = 10
    @FocusState private var isCheckAmountFocused: Bool
    private var totalAmount: Double {
        let tipAmount = checkAmount / 100 * Double(tipPercentage)
        let totalAmount = checkAmount + tipAmount
        return totalAmount
    }
    private var amountPerPerson: Double {
        let amountPerPerson = totalAmount / Double(numberOfPeople)
        return amountPerPerson
    }
    var body: some View {
        NavigationStack {
            Form {
                Section("Enter Check Amount") {
                    TextField(
                        "Check Amount",
                        value: $checkAmount,
                        format: .currency(
                            code: Locale.current.currency?.identifier ?? "USD"
                        )
                    )
                    .keyboardType(.numberPad)
                    .focused($isCheckAmountFocused)
                }
                Section("Select Number of People") {
                    Picker("Number of People", selection: $numberOfPeople) {
                        ForEach(2..<101, id: \.self) { numOfPeople in
                            Text("\(numOfPeople) people")
                        }
                    }
                    .pickerStyle(.automatic)
                }
                Section("Select Tip Percentage") {
                    Picker("Tip Percentage", selection: $tipPercentage) {
                        ForEach(0..<101, id: \.self) { tipPercentage in
                            Text(tipPercentage, format: .percent)
                        }
                    }
                    .pickerStyle(.navigationLink)
                }
                Section("Total Amount") {
                    Text(
                        amountPerPerson,
                        format: .currency(
                            code: Locale.current.currency?.identifier ?? "USD"
                        )
                    ).foregroundStyle(tipPercentage == 0 ? .red : .black)
                }
                Section("Amount per Person") {
                    Text(
                        amountPerPerson,
                        format: .currency(
                            code: Locale.current.currency?.identifier ?? "USD"
                        )
                    )
                }
            }
            .navigationTitle("WeSplit")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                if isCheckAmountFocused {
                    Button("Done") {
                        isCheckAmountFocused = false
                    }
                }
            }
        }
    }
}

#Preview {
    MainContentView()
}
