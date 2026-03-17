import Foundation

struct SourceSection: Identifiable {
    let id = UUID()
    var title: String
    var links: [SourceLink]
    var footer: String? = nil
}

struct SourceLink: Identifiable {
    let id = UUID()
    
    var title: String
    var source: String
    var image: SourceImage
    
    var link: String? = nil
}

enum SourceImage: String {
    case information = "character.text.justify"
    case image = "photo"
    case model = "move.3d"
}
