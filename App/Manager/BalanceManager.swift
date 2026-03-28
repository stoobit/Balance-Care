import Foundation

@Observable final class BalanceManager {
    // View
    var isExpanded: Bool = false
    var isPlaying: Bool = false
    var isAbout: Bool = false
    
    func reset() {
        id = nil
        isAbout = false
        isPlaying = false
        isExpanded = false
    }
    
    // Selection
    private(set) var selection: BalanceCheckModel? = nil
    
    func set(_ balanceCheck: BalanceCheckModel) {
        self.selection = balanceCheck
        
        let normalized = Array.normalize(balanceCheck.measurements)
        selection?.measurements = Array.smooth(normalized)
    }
    
    // Animation
    var playbackSpeed: PlaybackSpeed = .standard
    var duration: Double = 0.005
    var id: UUID?
}
