import SwiftUI

struct BookDetailsScreenView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @State private var isDeleteAlertPresented: Bool = false
    let book: Book
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .center, spacing: 20) {
                ZStack(alignment: .bottomTrailing) {
                    Image(book.genre)
                        .resizable()
                        .scaledToFill()
                        .containerRelativeFrame(.horizontal) { width, _ in
                            width
                        }
                    Text(book.genre.uppercased())
                        .font(.headline)
                        .foregroundStyle(.white)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 16)
                        .background(.ultraThinMaterial.opacity(0.6))
                        .clipShape(.capsule)
                        .offset(x: -12, y: -12)
                }.frame(maxWidth: .infinity, minHeight: 240, alignment: .center)
                VStack(alignment: .leading) {
                    Text(book.title)
                        .font(.title)
                        .foregroundStyle(.primary)
                    Text(book.authorName)
                        .font(.subheadline)
                        .foregroundStyle(.primary.opacity(0.8))
                }.frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                VStack(alignment: .leading) {
                    Text("Review")
                        .font(.headline)
                        .foregroundStyle(.primary)
                    Text(book.review)
                        .font(.body)
                        .foregroundStyle(.primary.opacity(0.8))
                }.frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                RatingView(
                    rating: .constant(book.rating),
                    labelFont: .headline
                ).frame(maxWidth: .infinity, alignment: .center)
                    .padding(.horizontal, 20)
                VStack {
                    Text(book.date.formatted(date: .abbreviated, time: .omitted))
                        .font(.callout)
                }.frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.horizontal, 20)
            }
        }.scrollBounceBehavior(.basedOnSize)
            .navigationTitle(book.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button("Delete", systemImage: "trash") {
                    isDeleteAlertPresented.toggle()
                }
            }
            .alert("Delete a book", isPresented: $isDeleteAlertPresented) {
                Button("Delete", role: .destructive) {
                    deleteBook()
                }
                Button("Cancel", role: .cancel) {}
            } message : {
                Text("Are you sure to delete this book?")
            }
    }
    func deleteBook() {
        modelContext.delete(book)
        dismiss()
    }
}

#Preview {
    BookDetailsScreenView(book: Book(title: "Test Title", authorName: "Test Author Name", genre: "Horror", review: "Test Review", rating: 4))
}
