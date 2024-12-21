import SwiftUI

struct CheckoutView: View {
    var orderState: OrderState
    @State private var confirmationMessage = ""
    @State private var showConfirmation = false
    @State private var errorMessage = ""
    @State private var showError = false
    var body: some View {
        ScrollView {
            VStack {
                AsyncImage(
                    url: URL(string: "https://hws.dev/img/cupcakes@3x.jpg"),
                    scale: 3
                ) { imagePhase in
                    if let image = imagePhase.image {
                        image
                            .resizable()
                            .scaledToFill()
                    } else if imagePhase.error != nil {
                        Text("There was an error loading an image.")
                    } else {
                        ProgressView()
                    }
                }.frame(height: 320)
                    .clipped()
                Spacer(minLength: 20)
                VStack {
                    Text(
                        "Your total cost is \(orderState.costUsd, format: .currency(code: "USD"))"
                    ).font(.title2)
                    Button("Place Order") {
                        Task {
                            await placeOrder()
                        }
                    }.buttonStyle(.borderedProminent)
                        .tint(.cyan)
                        .foregroundStyle(.white)
                }
            }
        }.ignoresSafeArea()
            .scrollBounceBehavior(.basedOnSize)
            .navigationTitle("Checkout")
            .navigationBarTitleDisplayMode(.inline)
            .alert("Thank You!", isPresented: $showConfirmation) {} message: {
                Text(confirmationMessage)
            }
            .alert("Try Again!", isPresented: $showError) {} message: {
                Text(errorMessage)
            }
    }
    func placeOrder() async {
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        guard let encodedData = try? encoder.encode(orderState) else {
            print("Failed to encode order.")
            errorMessage = "Something went wrong. Please try again."
            showError.toggle()
            return
        }
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = "POST"
        do {
            let (data, _) = try await URLSession.shared.upload(for: urlRequest, from: encodedData)
            let decodedOrder = try decoder.decode(OrderState.self, from: data)
            let orderQuantity = decodedOrder.orderQuantity
            let orderType = OrderState.orderTypes[decodedOrder.orderType].lowercased()
            confirmationMessage = "Your order for \(orderQuantity) \(orderType) cakes is placed successfully."
            showConfirmation.toggle()
        } catch {
            print("Failed to checkout order: \(error.localizedDescription)")
            errorMessage = "Unable to checkout your order. Please try again."
            showError.toggle()
        }
    }
}

#Preview {
    CheckoutView(
        orderState: OrderState()
    )
}
