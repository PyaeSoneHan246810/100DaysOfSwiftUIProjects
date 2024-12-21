import SwiftUI

struct AddressView: View {
    @Bindable var orderState: OrderState
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $orderState.name)
                TextField("Street Address", text: $orderState.streetAddress)
                TextField("City", text: $orderState.city)
                TextField("Zip Code", text: $orderState.zipCode)
            }
            Section {
                NavigationLink {
                    CheckoutView(
                        orderState: orderState
                    )
                } label: {
                    Text("Checkout")
                }
            }.disabled(!orderState.hasValidAddress)
        }.navigationTitle("Address")
            .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    AddressView(
        orderState: OrderState()
    )
}
