import SwiftUI

struct BalanceScoreOverview: View {
    var check: BalanceCheckModel
    
    var body: some View {
        HStack {
            let scale: CGFloat = 0.74
            BalanceFigure()
                .opacity(0)
                .glassEffect(.clear.tint(.accentColor), in: BalanceFigure())
                .frame(width: 55.05 * scale, height: 76.81 * scale)
            
            VStack(alignment: .leading) {
                Text("Your Balance is")
                    .foregroundStyle(Color.secondary)
                    .font(.caption)
                
                Text(check.score.title)
                    .foregroundStyle(Color.accentColor)
                    .font(.largeTitle.bold())
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel(Text("Your balance is \(check.score.title.lowercased())."))
        }
        .padding(.vertical, 7)
        .padding(.horizontal, 3)
        .listRowBackground(Color.clear)
        .listRowInsets(EdgeInsets())
        .listSectionSpacing(0)
    }
}
