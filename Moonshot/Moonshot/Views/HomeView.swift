import SwiftUI

struct HomeView: View {
    let missions: [Mission] = Bundle.main.decode("missions.json")
    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    @State private var currentLayout: String = "square.grid.2x2.fill"
    private let layoutOptions: [String] = ["square.grid.2x2.fill", "rectangle.grid.1x2.fill"]
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                if currentLayout == layoutOptions.first {
                    LazyVGrid(
                        columns: [GridItem(.adaptive(minimum: 150))],
                        spacing: 16
                    ) {
                        ForEach(missions) { mission in
                            NavigationLink(value: mission) {
                                MissionItem(mission: mission)
                            }
                        }
                    }.padding(16)
                        .transition(.blurReplace)
                } else {
                    LazyVStack(spacing: 16) {
                        ForEach(missions) { mission in
                            NavigationLink(value: mission) {
                                MissionItem(mission: mission)
                            }
                        }
                    }.padding(16)
                        .transition(.blurReplace)
                }
            }.background(.darkBackground)
                .navigationTitle("Moonshot")
                .toolbar {
                    Picker("Grid Layout", selection: $currentLayout.animation(.bouncy)) {
                        ForEach(layoutOptions, id: \.self) { layoutOption in
                            Image(systemName: layoutOption)
                        }
                    }.pickerStyle(.segmented)
                }
                .navigationDestination(for: Mission.self) { mission in
                    MissionView(
                        mission: mission,
                        astronauts: astronauts
                    )
                }
                .preferredColorScheme(.dark)
        }
    }
}

struct MissionItem: View {
    let mission: Mission
    var body: some View {
        VStack {
            Image(mission.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 100)
                .padding(12)
            VStack {
                Text(mission.displayName)
                    .font(.headline)
                    .foregroundStyle(.white)
                Text(mission.formattedLaunchDate)
            }.frame(maxWidth: .infinity)
                .padding()
                .background(.lightBackground)
                .foregroundStyle(.gray)
        }.clipShape(.rect(cornerRadius: 12))
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(.lightBackground, lineWidth: 1)
            }
    }
}

#Preview {
    HomeView()
}
