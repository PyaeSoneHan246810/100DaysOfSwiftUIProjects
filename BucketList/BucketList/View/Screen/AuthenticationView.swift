import SwiftUI

struct AuthenticationView: View {
    //MARK: VIEW MODEL
    @State private var viewModel = ViewModel()
    //MARK: BODY VIEW
    var body: some View {
        ZStack {
            if viewModel.isAuthenticated {
                LocationsView()
            } else {
                AuthenticationContentView(
                    onButtonClick: {
                        viewModel.authenticate()
                    }
                )
            }
        }.alert("Error", isPresented: $viewModel.hasError) {} message: {
            Text(viewModel.errorMessage ?? "")
        }
    }
 }

//MARK: PREVIEW
#Preview {
    AuthenticationView()
}
