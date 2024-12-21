import Foundation

struct Mission: Codable, Identifiable, Hashable {
    struct Crew: Codable, Hashable {
        let name: String
        let role: String
    }
    let id: Int
    let launchDate: Date?
    let crew: [Crew]
    let description: String
    
    var displayName: String {
        "Apollo \(id)"
    }
    var imageName: String {
        "apollo\(id)"
    }
    var formattedLaunchDate: String {
        launchDate?.formatted(date: .abbreviated, time: .omitted) ?? "N/A"
    }
}
