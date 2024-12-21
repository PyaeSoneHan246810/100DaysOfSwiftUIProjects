import SwiftData
import SwiftUI

struct BookListScreenView: View {
    @Environment(\.modelContext) var modelContext
    @Query(
        sort: [
            SortDescriptor(\Book.title),
            SortDescriptor(\Book.authorName)
        ]
    ) var books: [Book]
    @State private var isAddBookSheetPresented: Bool = false
    var body: some View {
        NavigationStack {
            List {
                ForEach(books) { book in
                    NavigationLink(value: book) {
                        BookListItemView(book: book)
                    }
                }.onDelete { indexSet in
                    indexSet.forEach { index in
                        let book = books[index]
                        deleteBook(book)
                    }
                }
            }.navigationTitle("Bookworm")
                .navigationDestination(for: Book.self) { book in
                    BookDetailsScreenView(book: book)
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Add", systemImage: "plus") {
                            isAddBookSheetPresented.toggle()
                        }
                    }
                    ToolbarItem(placement: .topBarLeading) {
                        EditButton()
                    }
                }
                .sheet(isPresented: $isAddBookSheetPresented) {
                    AddBookScreenView()
                }
        }
    }
    func deleteBook(_ book: Book) {
        modelContext.delete(book)
    }
}

#Preview {
    BookListScreenView()
}
