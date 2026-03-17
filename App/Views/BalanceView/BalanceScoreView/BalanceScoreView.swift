import SwiftUI

struct BalanceScoreView: View {
    @Environment(BalanceManager.self) var manager
    
    @Environment(\.colorSchemeContrast) var contrast
    @Environment(\.colorScheme) var colorScheme
    
    var color: Color
    var selection: BalanceScore
    
    var body: some View {
        HStack(spacing: 20) {
            ForEach(1..<5) { offset in
                let score = BalanceScore.allCases[offset - 1]
                
                if score == .unstable {
                    Triangle(offset: CGFloat(offset))
                        .score(
                            score, color: color, isSelected: selection == score,
                            colorScheme: colorScheme, contrast: contrast
                        )
                } else {
                    Trapezoid(offset: CGFloat(offset))
                        .score(
                            score, color: color, isSelected: selection == score,
                            colorScheme: colorScheme, contrast: contrast
                        )
                }
            }
        }
        .frame(height: 100)
        .padding(.horizontal, 9)
        .overlay(alignment: .topLeading) {
            Button("About", systemImage: "info.circle") {
                manager.isAbout.toggle()
            }
            .foregroundStyle(Color.primary)
            .labelStyle(.iconOnly)
            .buttonStyle(.plain)
            .padding(.top, 0.5)
        }
    }
}
