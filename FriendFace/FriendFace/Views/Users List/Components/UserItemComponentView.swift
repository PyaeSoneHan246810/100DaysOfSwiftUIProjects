import SwiftUI

struct UserItemComponentView: View {
    let user: User
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(user.name)
                    .font(.headline.weight(.semibold))
                Text(user.email)
                    .font(.caption)
            }
            Spacer()
            Circle()
                .frame(width: 12, height: 12)
                .foregroundStyle(user.isActive ? .green : .red)
        }
    }
}
