import SwiftData
import Foundation

@Model
class Friend: Codable, Identifiable {
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
    }
    
    var id: UUID
    var name: String
    var user: User?
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.name, forKey: .name)
    }
}
