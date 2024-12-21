import Foundation

struct Result: Codable {
    let query: Query
}

struct Query: Codable {
    let pages: [String: Page]
}

struct Page: Codable, Comparable {
    enum CodingKeys: String, CodingKey {
        case pageId = "pageid"
        case title
        case terms
    }
    let pageId: Int
    let title: String
    let terms: [String: [String]]?
    var description: String {
        terms?["description"]?.first ?? "No further information available."
    }
    
    static func < (lhs: Page, rhs: Page) -> Bool {
        lhs.title < rhs.title
    }
}
