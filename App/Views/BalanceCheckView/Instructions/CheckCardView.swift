import SwiftUI

struct CheckCardView: View {
    @Environment(\.colorSchemeContrast) var contrast
    @Environment(\.colorScheme) var colorScheme
    
    var balanceChecks: [BalanceCheckWrapper]
    var card: CheckInstructionView.Card
    
    var width: CGFloat
    
    var body: some View {
        ViewThatFits {
            CardContent()
            
            ScrollView {
                CardContent()
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }
    
    private var backgroundColor: Color {
        return colorScheme == .dark ? Color("DefaultListRowColor") : Color(.systemGroupedBackground)
    }
    
    @ViewBuilder func CardContent() -> some View {
        VStack(spacing: 25) {
            Image(card.image(contrast: contrast, colorScheme: colorScheme))
                .resizable()
                .scaledToFill()
                .offset(y: card == .positioning ? 12 : 0)
                .padding(card == .positioning ? 20 : 10)
                .frame(width: width, height: width)
                .background(backgroundColor)
                .clipShape(.rect(cornerRadius: 25))
            
            VStack(alignment: .leading, spacing: 15) {
                Text(card.title)
                    .font(.title2.bold())
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                    .fixedSize(
                        horizontal: false, vertical: true
                    )
                
                Text(card.subtitle(balanceChecks: balanceChecks))
                    .font(.callout)
                    .foregroundStyle(Color.secondary)
                    .multilineTextAlignment(.leading)
                    .fixedSize(
                        horizontal: false, vertical: true
                    )
            }
            .transition(.blurReplace)
            .frame(width: width, alignment: .leading)
            .scrollTransition(
                .interactive(timingCurve: .easeIn), axis: .horizontal
            ) { content, phase  in
                return content
                    .scaleEffect(phase.isIdentity ? 1 : 0.9)
            }
        }
    }
}
