import SwiftUI

struct AboutCardView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var card: AboutModel
    var width: CGFloat
    
    var body: some View {
        ViewThatFits(in: .vertical) {
            CardContent()
            
            HStack {
                ScrollView {
                    CardContent()
                }
                .scrollIndicators(.hidden)
            }
            .frame(maxWidth: .infinity)
        }
        .frame(width: width * 0.78)
        .background(cardColor)
        .clipShape(.rect(cornerRadius: 30))
        .scrollTransition(axis: .horizontal) { content, phase in
            let degrees: CGFloat = (phase.value < 0 ? 10 : -10)
            
            return content
                .scaleEffect(phase.isIdentity ? 1 : 0.95)
                .rotation3DEffect(
                    Angle(degrees: phase.isIdentity ? 0 : degrees),
                    axis: (x: 0, y: 1, z: 0)
                )
        }
    }
    
    private var cardColor: Color {
        colorScheme == .dark ? Color("SheetListRowColor") : Color(.systemGroupedBackground)
    }
    
    @ViewBuilder func CardContent() -> some View {
        VStack(alignment: .leading, spacing: 15) {
            Image(systemName: card.image)
                .font(.system(size: 50))
                .foregroundStyle(Color.accentColor)
                .frame(height: 85)
                .frame(maxWidth: .infinity)
            
            VStack(alignment: .leading, spacing: 20) {
                Text(card.title)
                    .font(.title2.bold())
                
                Text(card.description)
                    .lineSpacing(10)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(21)
    }
}
