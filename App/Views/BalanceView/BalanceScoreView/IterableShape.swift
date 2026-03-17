import SwiftUI

protocol IterableShape: Shape, View {
    var offset: CGFloat { get }
}

extension IterableShape {
    @ViewBuilder
    func score(
        _ score: BalanceScore, color: Color, isSelected: Bool,
        colorScheme: ColorScheme, contrast: ColorSchemeContrast
    ) -> some View {
        let textColor = textColor(color: color, colorScheme: colorScheme, contrast: contrast)
        let color = isSelected ? color : secondaryColor(for: colorScheme)
        
        VStack(spacing: 15) {
            self
                .stroke(style: .init(
                    lineWidth: 11, lineCap: .round, lineJoin: .round)
                )
                .fill(color)
                .background(self.foregroundStyle(color))
                .overlay(alignment: .bottomTrailing) {
                    Text("\(Int(offset))")
                        .foregroundStyle(isSelected ? textColor : Color.primary)
                        .font(.caption2)
                        .offset(y: 2)
                }
            
            Text(score.title)
                .font(.caption)
                .foregroundStyle(Color.primary)
                .multilineTextAlignment(.center)
                .lineLimit(2, reservesSpace: true)
        }
    }
    
    private func secondaryColor(for colorScheme: ColorScheme) -> Color {
        let color: Color = colorScheme == .dark ? .black : .white
        return color.mix(with: .gray, by: colorScheme == .dark ? 0.4 : 0.25)
    }
    
    private func textColor(
        color: Color, colorScheme: ColorScheme, contrast: ColorSchemeContrast
    ) -> Color {
        if contrast == .increased {
            return colorScheme == .dark ? .black : Color.white
        }
        
        return color == .accentColor ? Color.black : Color.white
    }
}
