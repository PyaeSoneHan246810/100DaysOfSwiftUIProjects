import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack(spacing: 12) {
            ProgressView()
                .controlSize(.large)
                .tint(Color.mint)
            Text("Loading nearby places...")
        }.frame(maxWidth: .infinity)
    }
}

#Preview {
    LoadingView()
}
