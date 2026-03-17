import Foundation

enum PlaybackSpeed: Double, Identifiable, CaseIterable {
    var id: String { label }
    
    case slow = 0.5
    case standard = 1.0
    case fast = 2.0
    
    var label: String {
        return "\(self.rawValue)x"
    }
}
