import SwiftUI

struct NearybyPlacesView: View {
    let pages: [Page]
    var body: some View {
        ForEach(pages, id: \.pageId) { page in
            Text(page.title)
                .font(.headline)
            + Text(": ")
            + Text(page.description)
                .italic()
        }
    }
}

#Preview {
    NearybyPlacesView(
        pages: [
            Page(
                pageId: 0,
                title: "Example Title 1",
                terms: [
                    "description": [
                        "Example Desccription"
                    ]
                ]
            ),
            Page(
                pageId: 1,
                title: "Example Title 2",
                terms: [
                    "description": [
                        "Example Desccription"
                    ]
                ]
            )
        ]
    )
}
