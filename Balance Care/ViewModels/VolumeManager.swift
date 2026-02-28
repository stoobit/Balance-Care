import SwiftUI
import AVFoundation

@MainActor
@Observable class VolumeManager: NSObject {
    var volume: Float = 0.0
    
    @ObservationIgnored
    private var audioSession = AVAudioSession.sharedInstance()
    
    @ObservationIgnored
    private var observation: NSKeyValueObservation?

    override init() {
        do {
            super.init()
            
            try self.audioSession.setActive(true)
            self.volume = audioSession.outputVolume
            
            observation = audioSession.observe(\.outputVolume) { [weak self] (session, _) in
                DispatchQueue.main.async {
                    self?.volume = session.outputVolume
                }
            }
        } catch {
            self.volume = 1
        }
    }
    
    deinit {
        observation?.invalidate()
    }
}
