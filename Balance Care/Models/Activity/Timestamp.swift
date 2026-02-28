import Foundation

enum Timestamp: Int, Codable, CaseIterable {
    case morning = 0
    case midday = 1
    case afternoon = 2
    
    var title: String {
        switch self {
        case .morning:
            "morning"
        case .midday:
            "midday"
        case .afternoon:
            "afternoon"
        }
    }
    
    var action: ActionType {
        switch self {
        case .morning:
                .morningExercise
        case .midday:
                .middayExercise
        case .afternoon:
                .afternoonExercise
        }
    }
    
    var range: Range<Int> {
        switch self {
        case .morning:
            Date.morning
        case .midday:
            Date.midday
        case .afternoon:
            Date.afternoon
        }
    }
}
