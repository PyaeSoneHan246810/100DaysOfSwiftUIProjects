import SwiftUI

struct ExpenseItemComponentView: View {
    let expense: Expense
    var categoryColor: Color {
        switch expense.category {
        case ExpenseCategory.personal.rawValue:
            return Color.indigo
        case ExpenseCategory.business.rawValue:
            return Color.teal
        default:
            return Color.primary
        }
    }
    var body: some View {
        HStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(expense.name)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.primary)
                    Text(expense.category)
                        .font(.footnote)
                        .foregroundStyle(categoryColor)
                }
            }
            Spacer(
                minLength: 12
            )
            Text(expense.amount.formatted(.currency(code: Locale.current.currency?.identifier ?? "USD")))
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.primary)
        }
    }
}

#Preview {
    ExpenseItemComponentView(
        expense: Expense(name: "Expense Name", amount: 2000.0, category: ExpenseCategory.personal.rawValue)
    )
}
