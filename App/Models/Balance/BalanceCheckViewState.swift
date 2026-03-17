import SwiftUI

enum BalanceCheckViewState {
    case ready
    case running
    case finished
    
    var swipeAction: String {
        switch self {
        case .ready:
            "Cancel"
        case .running:
            "Restart"
        case .finished:
            "Continue"
        }
    }
    
    var description: String {
        switch self {
        case .ready:
            return "Put your iPhone in your pocket and say “Start” when you’re in Tandem Stance."
        case .running:
            return "The Balance Check is in progress."
        case .finished:
            return "The Balance Check has finished."
        }
    }
    
    var image: String {
        switch self {
        case .ready:
            "waveform.badge.microphone"
        case .running:
            "waveform.path.ecg"
        case .finished:
            "checkmark.circle"
        }
    }
    
    var primaryColor: Color {
        switch self {
        case .ready:
            return Color.primary
        case .running:
            return Color.secondaryAccentColor
        case .finished:
            return Color.accentColor
        }
    }
    
    var secondaryColor: Color {
        switch self {
        case .ready:
            return Color.secondaryAccentColor
        case .running:
            return Color.primary
        case .finished:
            return Color.accentColor
        }
    }
    
    var slider: String {
        switch self {
        case .ready:
            return "xmark"
        case .running:
            return "arrow.circlepath"
        case .finished:
            return "chevron.right"
        }
    }
}
