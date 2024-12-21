import Foundation
import LocalAuthentication

extension AuthenticationView {
    @Observable
    class ViewModel {
        var hasError: Bool = false
        private(set) var errorMessage: String?
        private(set) var isAuthenticated: Bool = false
        
        func authenticate() {
            let laContext = LAContext()
            var error: NSError?
            if laContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                //biometric authentication available
                let reason = "Please authenticate to access your private data."
                laContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { isSuccess, error in
                    if isSuccess {
                        //authentication was successful
                        self.hasError = false
                        self.errorMessage = nil
                        self.isAuthenticated = true
                    } else {
                        //authentication was failed
                        self.hasError = true
                        self.errorMessage = error?.localizedDescription
                        self.isAuthenticated = false
                    }
                }
            } else {
                //biometric authentication unavailable
                self.hasError = true
                self.errorMessage = "Biometric authentication unavailable."
                self.isAuthenticated = false
            }
        }
    }
}
