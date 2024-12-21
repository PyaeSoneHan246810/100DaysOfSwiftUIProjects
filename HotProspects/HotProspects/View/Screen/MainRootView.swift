import SwiftUI

struct MainRootView: View {
    var body: some View {
        TabView {
            ProspectsView(
                prospectType: .everyone
            ).tabItem {
                Label(
                    "Everyone",
                    systemImage: "person.3"
                )
            }
            ProspectsView(
                prospectType: .contacted
            ).tabItem {
                Label(
                    "Contacted",
                    systemImage: "checkmark.circle"
                )
            }
            ProspectsView(
                prospectType: .uncontacted
            ).tabItem {
                Label(
                    "Uncontacted",
                    systemImage: "questionmark.circle"
                )
            }
            MeView()
                .tabItem {
                    Label(
                        "Me",
                        systemImage: "person.crop.square"
                    )
                }
        }.tint(.mint)
    }
}

#Preview {
    MainRootView()
}
