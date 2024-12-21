import SwiftUI

struct MainRootView: View {
    @AppStorage("isAuthenticationEnabled") private var isAuthenticationEnabled: Bool = true
    
    var body: some View {
        if isAuthenticationEnabled {
            AuthenticationView()
        } else {
            ContactsView()
        }
    }
}

#Preview {
    MainRootView()
}
