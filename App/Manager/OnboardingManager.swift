import SwiftUI
import TipKit

@Observable final class OnboardingManager {
    init() {
        handleOnboarding()
    }
    
    // Sheet
    var showSheet: Bool = true
    
    // Onboarding Views
    var showMicrophoneSettings: Bool = false
    var showNotificationSettings: Bool = false
    
    // Initialization Error
    var showErrorAlert: Bool = false
    
    // Helper
    func complete() {
        UserDefaults.standard.set("done", forKey: "onboarding")
        try? Tips.configure()
    }
    
    private func handleOnboarding() {
        if UserDefaults.standard.value(forKey: "onboarding") == nil {
            showSheet = true
            return
        }
        
        showSheet = false
    }
}
