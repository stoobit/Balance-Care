import Foundation

enum BalanceProgress: Codable {
    case improvement
    case deterioration
    case unchanged
    
    static func progress(score: BalanceScore, average: Double) -> Self {
        let scoreValue = Double(score.rawValue)
        let epsilon = 1e-9

        if scoreValue > average + epsilon {
            return .improvement
        } else if abs(scoreValue - average) <= epsilon {
            return .unchanged
        } else {
            return .deterioration
        }
    }
    
    var image: String {
        switch self {
        case .improvement:
            "arrow.up.right.circle"
        case .deterioration:
            "arrow.down.right.circle"
        case .unchanged:
            "arrow.forward.circle"
        }
    }

    var accessibilityTitle: String {
        switch self {
        case .improvement:
            return "Improving"
        case .deterioration:
            return "Declining"
        case .unchanged:
            return "Unchanged"
        }
    }
}

