import SwiftData
import Foundation

@Model
class Prospect {
    var name: String
    var emailAddress: String
    var isContacted: Bool
    var createdAt: Date
    init(name: String, emailAddress: String, isContacted: Bool) {
        self.name = name
        self.emailAddress = emailAddress
        self.isContacted = isContacted
        self.createdAt = .now
    }
}

extension Prospect {
    static let previewProspect = Prospect(
        name: "John Doe",
        emailAddress: "john@doe.com",
        isContacted: false
    )
}
