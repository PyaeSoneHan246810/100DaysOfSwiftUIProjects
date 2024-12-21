import SwiftUI

struct OrderOptionsView: View {
    @State private var orderState = OrderState()
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker(
                        "Select your cake type.",
                        selection: $orderState.orderType
                    ) {
                        ForEach(
                            OrderState.orderTypes.indices,
                            id: \.self
                        ) { index in
                            Text(OrderState.orderTypes[index])
                        }
                    }
                    Stepper(
                        "Number of cakes: \(orderState.orderQuantity)",
                        value: $orderState.orderQuantity,
                        in: 3...20,
                        step: 1
                    )
                }
                Section {
                    Toggle(
                        "Any special requests?",
                        isOn: $orderState.hasSpecialRequests.animation()
                    ).tint(.cyan)
                    if orderState.hasSpecialRequests {
                        Toggle(
                            "Add extra frosting?",
                            isOn: $orderState.addExtraFrosting.animation()
                        ).tint(.cyan)
                        Toggle(
                            "Add sprinkles?",
                            isOn: $orderState.addSprinkles.animation()
                        ).tint(.cyan)
                    }
                }
                Section {
                    NavigationLink {
                        AddressView(
                            orderState: orderState
                        )
                    } label: {
                        Text("Delivery Details")
                    }
                }
            }.navigationTitle("CupcakeCorner")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    OrderOptionsView()
}
