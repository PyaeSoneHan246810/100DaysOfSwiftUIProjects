import SwiftUI

struct AstronautView: View {
    let astronaut: Astronaut
    var body: some View {
        ScrollView {
            VStack {
                Image(astronaut.id)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .clipShape(.rect(cornerRadius: 20))
                Spacer(minLength: 20)
                Text(astronaut.description)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(16)
        }.background(.darkBackground)
        .navigationTitle(astronaut.name)
    }
}

#Preview {
    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    AstronautView(
        astronaut: astronauts["white"]!
    ).preferredColorScheme(.dark)
}
