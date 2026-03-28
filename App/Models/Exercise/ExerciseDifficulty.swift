import SwiftUI

enum ExerciseDifficulty: String, Codable, CaseIterable {
    case easy = "Easy"
    case medium = "Medium"
    case difficult = "Difficult"
    
    var score: Int {
        switch self {
        case .easy:
            return 1
        case .medium:
            return 2
        case .difficult:
            return 3
        }
    }
    
    var color: Color {
        switch self {
        case .easy:
            return .green
        case .medium:
            return .yellow
        case .difficult:
            return .red
        }
    }
}
