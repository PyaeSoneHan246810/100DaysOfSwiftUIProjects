import SwiftUI

struct FailureView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "info.circle")
                .resizable()
                .scaledToFit()
                .frame(width: 32, height: 32)
                .foregroundStyle(Color.mint)
            Text("Unable to load nearby places.")
        }.frame(maxWidth: .infinity)
    }
}

#Preview {
    FailureView()
}
