import SwiftUI

extension CheckInstructionView {
    enum Card: String, Identifiable, CaseIterable {
        var id: String { self.rawValue }
        
        case exercise
        case positioning
        
        func image(contrast: ColorSchemeContrast, colorScheme: ColorScheme) -> String {
            switch self {
            case .exercise:
                return "tandemstance"
            case .positioning:
                if contrast == .increased && colorScheme == .light {
                    return "trousers.smartphone.right.contrast"
                }
                
                return "trousers.smartphone.right"
            }
        }
        
        var title: String {
            switch self {
            case .exercise:
                return "Tandem Stance"
            case .positioning:
                return "Placing Your iPhone"
            }
        }
        
        func subtitle(balanceChecks: [BalanceCheckWrapper]) -> String {
            if self == .positioning {
                return "Once the Balance Check begins, place your iPhone on your back support leg, with the screen facing your body."
            }
            
            guard let score = balanceChecks.first?.balanceCheck.score else {
                return semiTandemStance
            }
            
            return score.rawValue < 3 ? semiTandemStance : tandemStance
        }
        
        private var semiTandemStance: String {
            "Stand with one foot slightly ahead of the other, so the heel of one foot is beside the toes of the other. Keep your feet in line, your knees relaxed, and your arms resting naturally at your sides."
        }
        private var tandemStance: String {
            "Stand with one foot directly in front of the other, so the heel of one foot is directly in line with the toes of the other. Keep your feet in line, your knees relaxed, and your arms resting naturally at your sides."
        }
    }
}
