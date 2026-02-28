import SwiftUI

struct BalanceInfoSection: View {
    @Environment(BalanceManager.self) var manager
    
    var body: some View {
        if let balanceCheck = manager.selection {
            HStack {
                if let progress = balanceCheck.progress {
                    Image(systemName: progress.image)
                        .accessibilityLabel(Text(progress.accessibilityTitle))
                        .foregroundStyle(Color.primary)
                }
                
                Text(balanceCheck.score.title)
                    .foregroundStyle(Color.accentColor)
                    .fontDesign(.monospaced)
            }
        }
    }
}
