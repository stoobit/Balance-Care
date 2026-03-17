import Foundation

enum ExerciseType: String, Codable {
    case symmetric
    case asymmetric
    
    var image: String {
        switch self {
        case .symmetric:
            return "square.and.line.vertical.and.square"
        case .asymmetric:
            return "square.filled.and.line.vertical.and.square"
        }
    }
}
