import SwiftUI

struct AuthenticationContentView: View {
    let onButtonClick: () -> Void
    var body: some View {
        ZStack {
            Color.mint.ignoresSafeArea()
            VStack(spacing: 20) {
                Text("BucketList")
                    .font(.largeTitle.weight(.heavy))
                    .foregroundStyle(.white)
                Button(
                    action: onButtonClick
                ) {
                    Text("Authenticate")
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(Color.white)
                }.buttonStyle(.borderedProminent)
                    .buttonBorderShape(ButtonBorderShape.capsule)
                    .tint(.black)
                    .controlSize(.large)
            }
        }
    }
}

#Preview {
    AuthenticationContentView(
        onButtonClick: {}
    )
}
