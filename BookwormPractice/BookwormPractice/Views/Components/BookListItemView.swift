import SwiftUI

struct BookListItemView: View {
    let book: Book
    var body: some View {
        HStack(spacing: 12) {
            EmojiRatingView(
                rating: book.rating
            ).font(.largeTitle)
            VStack(alignment: .leading) {
                Text(book.title)
                    .font(.headline)
                    .foregroundStyle(book.rating > 1 ? .black : .red)
                Text(book.authorName)
                    .font(.body)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Text(book.genre)
        }.frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    BookListItemView(book: Book(title: "Test Title", authorName: "Test Author Name", genre: "Fantasy", review: "Test Review", rating: 4))
}
