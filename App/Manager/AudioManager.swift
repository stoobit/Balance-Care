import AVFoundation
import Observation

@Observable
final class AudioManager: NSObject, AVAudioPlayerDelegate {
    var audioPlayer: AVAudioPlayer?
    var isPlaying: Bool = false
    
    override init() {
        super.init()
    }
    
    private func configureAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .spokenAudio)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set audio session category: \(error)")
        }
    }
    
    func speak(_ sequence: Sequence, type: String = "wav") throws {
        configureAudioSession()
        
        let name = sequence.rawValue
        let fileName = "\(name)_en"
        
        guard let path = Bundle.main.path(forResource: fileName, ofType: type) else {
            throw SpeechError.fileNotFound
        }
        
        let url = URL(fileURLWithPath: path)
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.delegate = self
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            
            isPlaying = true
        } catch {
            print("Playback failed: \(error)")
        }
    }
    
    func stop() {
        audioPlayer?.stop()
        isPlaying = false
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isPlaying = false
        print("Audio finished playing successfully: \(flag)")
    }
    
    enum Sequence: String {
        case start = "start"
        case half = "half"
        case finished = "finished"
    }
    
    private enum SpeechError: LocalizedError {
        case fileNotFound
        
        var errorDescription: String? {
            switch self {
            case .fileNotFound: 
                return "The audio file could not be found in the bundle."
            }
        }
    }
}

