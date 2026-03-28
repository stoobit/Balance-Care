import AVFoundation
import Foundation
import AlarmKit

/// adding AlarmKit to capabilites isn't available yet
/// functionality gets extended when Swift Packages support AlarmKit


@Observable final class AlarmManager {
#if targetEnvironment(macCatalyst)
#else
    @ObservationIgnored private var alarmManager = AlarmKit.AlarmManager.shared
#endif
    
    func requestAuthorization() {
#if targetEnvironment(macCatalyst)
#else
        Task {
            do {
                let manager = AlarmKit.AlarmManager.shared
                let _ = try await manager.requestAuthorization()
            } catch {
                print("Error:", error)
            }
        }
#endif
    }
    
    // temporary
    func _playAlarm(_ remaining: Double) {
        if remaining == 0 {
            AudioServicesPlayAlertSound(1009)
        }
    }
}
