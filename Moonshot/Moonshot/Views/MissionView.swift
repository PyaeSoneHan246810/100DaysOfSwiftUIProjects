import SwiftUI

struct MissionView: View {
    let mission: Mission
    let crewMembers: [CrewMember]
    var body: some View {
        ScrollView(showsIndicators: false) {
            MissionImage(
                image: mission.imageName
            ).padding([.horizontal, .vertical], 16)
            CustomDivider()
            Details(
                title: "Mission Highlights",
                description: mission.description
            ).padding([.horizontal, .vertical], 16)
            CustomDivider()
            Text("Crew")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.horizontal, .vertical], 16)
                .font(.title.bold())
                .foregroundStyle(.white)
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 12) {
                    ForEach(crewMembers, id: \.self.astronaut.id) { crewMember in
                        NavigationLink(value: crewMember) {
                            CrewMemberItem(crewMember: crewMember)
                        }                    }
                }.padding(.horizontal, 16)
            }.padding(.bottom, 16)
            CustomDivider()
            Details(
                title: "Launch Date",
                description: mission.formattedLaunchDate
            ).padding([.horizontal, .vertical], 16)
        }.background(.darkBackground)
            .navigationTitle(mission.displayName)
            .navigationDestination(for: CrewMember.self) { crewMember in
                AstronautView(astronaut: crewMember.astronaut)
            }
    }
    init(mission: Mission, astronauts: [String: Astronaut]) {
        self.mission = mission
        self.crewMembers = mission.crew.map { crew in
            guard let astronaut = astronauts[crew.name] else {
                fatalError()
            }
            return CrewMember(role: crew.role, astronaut: astronaut)
        }
    }
}

struct MissionImage: View {
    let image: String
    var body: some View {
        Image(image)
            .resizable()
            .scaledToFill()
            .containerRelativeFrame(.horizontal) { width, axis in
                width * 0.5
            }
    }
}

struct CustomDivider: View {
    var body: some View {
        Rectangle()
            .foregroundStyle(.lightBackground)
            .frame(height: 2)
    }
}

struct Details: View {
    let title: String
    let description: String
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.title.bold())
                .foregroundStyle(.white)
            Spacer(
                minLength: 20
            )
            Text(description)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(.white)
        }.frame(maxWidth: .infinity)
    }
}

struct CrewMember: Hashable {
    let role: String
    let astronaut: Astronaut
}

struct CrewMemberItem: View {
    let crewMember: CrewMember
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Image(crewMember.astronaut.id)
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity)
                .clipShape(.rect(cornerRadius: 12))
            VStack(alignment: .leading) {
                Text(crewMember.astronaut.name)
                    .font(.subheadline)
                    .foregroundStyle(.white)
                Text(crewMember.role)
                    .font(.footnote)
                    .foregroundStyle(.gray)
            }.padding(.vertical, 8).padding(.horizontal, 8)
        }.frame(width: 200)
            .background(.lightBackground)
            .clipShape(.rect(cornerRadius: 12))
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(.white, lineWidth: 1)
            }
    }
}

#Preview {
    let missions: [Mission] = Bundle.main.decode("missions.json")
    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    MissionView(
        mission: missions.randomElement()!,
        astronauts: astronauts
    ).preferredColorScheme(.dark)
}
