import SwiftUI

enum BalanceScore: Int, CaseIterable, Codable {
    case none
    
    case unstable = 1
    case somewhatStable = 2
    case stable = 3
    case veryStable = 4
    
    init(from string: String) throws {
        let string = string.replacing("_", with: "")
        
        switch string {
        case "unstable":
            self = .unstable
        case "somewhatstable":
            self = .somewhatStable
        case "stable":
            self = .stable
        case "verystable":
            self = .veryStable
        default:
            throw InitalizationError.failed
        }
    }
    
    static var allCases: [BalanceScore] {
        [.unstable, .somewhatStable, .stable, .veryStable]
    }

    var title: String {
        switch self {
        case .unstable:
            return "Unstable"
        case .somewhatStable:
            return "Somewhat Stable"
        case .stable:
            return "Stable"
        case .veryStable:
            return "Very Stable"
        default:
            return .empty
        }
    }
    
    func recommendations(using exercises: [ExerciseWrapper]) -> [ExerciseWrapper] {
        let range: ClosedRange<Int>? = switch self {
        case .none:
            nil
        case .unstable:
            0...2
        case .somewhatStable:
            2...4
        case .stable:
            4...6
        case .veryStable:
            6...8
        }
        
        guard let range else { return [] }
        return Array(exercises[range])
    }
    
    enum InitalizationError: LocalizedError {
        case failed
        
        var errorDescription: String? {
            return "The string could not be converted into a corresponding enum value."
        }
    }
}
