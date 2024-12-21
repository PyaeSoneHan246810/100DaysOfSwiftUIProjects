import SwiftUI
import LocalAuthentication

struct AuthenticationView: View {
    @State private var isAuthenticated: Bool = false
    
    var body: some View {
        if isAuthenticated {
            ContactsView()
        } else {
            ContentView(
                onContinueClick: {
                    authenticate()
                }
            )
        }
    }
    
    private func authenticate() {
        let context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Authentication is required to unlock the app."
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { isSuccess, error in
                if isSuccess {
                    isAuthenticated = true
                } else {
                    isAuthenticated = false
                }
            }
        } else {
            isAuthenticated = false
        }
    }
}

extension AuthenticationView {
    struct ContentView: View {
        let onContinueClick: () -> Void
        var body: some View {
            ContentUnavailableView {
                VStack(spacing: 12.0) {
                    Image(systemName: "faceid")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100.0, height: 100.0)
                        .foregroundStyle(.secondary)
                    Text("Please signin with FaceID.")
                        .foregroundStyle(.primary)
                }.padding()
            } actions: {
                Button("Continue") {
                    onContinueClick()
                }.buttonStyle(.borderedProminent)
                    .controlSize(.regular)
                    .tint(.mint)
            }
        }
    }
}

#Preview {
    AuthenticationView()
}
