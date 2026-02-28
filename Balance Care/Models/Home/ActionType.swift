import SwiftUI

enum ActionType: String, Codable {
    case balanceCheck
    case waiting
    
    case morningExercise
    case middayExercise
    case afternoonExercise
    
    var title: String {
        switch self {
        case .balanceCheck:
            "Balance Check"
        case .morningExercise:
            "Morning Exercise"
        case .middayExercise:
            "Midday Exercise"
        case .afternoonExercise:
            "Afternoon Exercise"
        case .waiting:
            "Take a Rest"
        }
    }
    
    var image: String {
        switch self {
        case .balanceCheck:
            "waveform.path.ecg"
        case .waiting:
            "bed.double.fill"
        default:
            "figure.cross.training"
        }
    }
    
    var color: Color {
        switch self {
        case .balanceCheck:
            Color.secondaryAccentColor
        default:
            Color.accentColor
        }
    }
    
    var next: ActionType {
        switch self {
        case .morningExercise:
            return .middayExercise
        case .middayExercise:
            return .afternoonExercise
        case .afternoonExercise:
            return .morningExercise
        case .balanceCheck:
            return .waiting
        case .waiting:
            return .waiting
        }
    }
    
    var timeDescription: String {
        switch self {
        case .balanceCheck:
            ""
        case .waiting:
            ""
        case .morningExercise:
            "tomorrow morning"
        case .middayExercise:
            "this midday"
        case .afternoonExercise:
            "this afternoon"
        }
    }
}

enum ActivityType {
    case exercise
    case balanceCheck
    
    var color: Color {
        switch self {
        case .exercise:
            Color.accentColor
        case .balanceCheck:
            Color.secondaryAccentColor
        }
    }
}
