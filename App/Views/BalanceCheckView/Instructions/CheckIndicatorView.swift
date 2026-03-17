import SwiftUI

struct CheckIndicatorView: View {
    typealias Card = CheckInstructionView.Card
    var selection: Card?
    
    var body: some View {
        HStack {
            ForEach(Card.allCases) { card in
                Circle()
                    .frame(width: 7, height: 7)
                    .foregroundStyle(
                        selection == card ? Color.accentColor : Color.secondary.opacity(0.5)
                    )
            }
        }
        .animation(.smooth, value: selection)
    }
}
