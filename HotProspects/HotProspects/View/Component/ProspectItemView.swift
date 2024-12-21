import SwiftUI

struct ProspectItemView: View {
    let prospect: Prospect
    let prospectType: ProspectsView.ProspectType
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(prospect.name)
                    .font(.headline)
                    .foregroundStyle(.primary)
                Text(prospect.emailAddress)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            if prospectType == .everyone {
                if prospect.isContacted {
                    Image(systemName: "person.crop.circle.fill.badge.checkmark")
                        .foregroundStyle(.green)
                } else {
                    Image(systemName: "person.crop.circle.badge.xmark")
                        .foregroundStyle(.blue)
                }
            }
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    ProspectItemView(
        prospect: Prospect.previewProspect,
        prospectType: .everyone
    )
}
