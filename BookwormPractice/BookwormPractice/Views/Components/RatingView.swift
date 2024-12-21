import SwiftUI

struct RatingView: View {
    @Binding var rating: Int
    var maxRating: Int = 5
    var showLable: Bool = true
    var label: String = "Rating"
    var labelFont: Font = .body
    var lableForegroundColor: Color = .primary
    var onImage: Image = Image(systemName: "star.fill")
    var offImage: Image = Image(systemName: "star.fill")
    var onImageColor: Color = .yellow
    var offImageColor: Color = .gray
    var body: some View {
        HStack {
            if showLable {
                Text(label)
                    .font(labelFont)
                    .foregroundStyle(lableForegroundColor)
                Spacer()
            }
            ForEach(1..<maxRating + 1, id: \.self) { number in
                Button {
                    rating = number
                } label: {
                    if number <= rating {
                        onImage
                            .foregroundStyle(onImageColor)
                    } else {
                        offImage
                            .foregroundStyle(offImageColor)
                    }
                }
            }
        }
    }
}

#Preview {
    RatingView(
        rating: .constant(4),
        maxRating: 5,
        showLable: true,
        label: "Custom Rating Bar",
        labelFont: .headline,
        lableForegroundColor: .red
    )
}
