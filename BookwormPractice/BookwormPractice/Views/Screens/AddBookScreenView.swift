import SwiftData
import SwiftUI

struct AddBookScreenView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @State private var title: String = ""
    @State private var authorName: String = ""
    @State private var genre: String = "Fantasy"
    @State private var review: String = ""
    @State private var rating: Int = 3
    let genres = ["Fantasy", "Horror", "Kids", "Mystery", "Potery", "Romance", "Thriller"]
    @State private var errorAlertMessage = ""
    @State private var isErrorAlertVisible: Bool = false
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField(
                        "Title of a book",
                        text: $title
                    )
                    TextField(
                        "Author of a book",
                        text: $authorName
                    )
                    Picker("Genre", selection: $genre) {
                        ForEach(genres, id: \.self) { genre in
                            Text(genre)
                        }
                    }.pickerStyle(.menu)
                }
                Section {
                    TextField("Review for a book", text: $review, axis: .vertical)
                    RatingView(rating: $rating)
                        .buttonStyle(.plain)
                }
                Section {
                    Button("Add") {
                        addBook()
                    }.buttonStyle(.borderedProminent)
                        .tint(.mint)
                        .foregroundStyle(.white)
                }
            }.navigationTitle("Add Book")
                .alert(
                    "Couldn't add book",
                    isPresented: $isErrorAlertVisible
                ) {} message: {
                    Text(errorAlertMessage)
                }
        }
    }
    func addBook() {
        guard !title.isEmpty else {
            errorAlertMessage = "Please enter a title"
            isErrorAlertVisible.toggle()
            return
        }
        guard !authorName.isEmpty else {
            errorAlertMessage = "Please enter an author name"
            isErrorAlertVisible.toggle()
            return
        }
        guard !review.isEmpty else {
            errorAlertMessage = "Please enter a review"
            isErrorAlertVisible.toggle()
            return
        }
        let book = Book(title: title, authorName: authorName, genre: genre, review: review, rating: rating)
        modelContext.insert(book)
        dismiss()
    }}

#Preview {
    AddBookScreenView()
}
