import SwiftUI

struct BalanceBackgroundView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var divisions: Int = 8
    var lineWidth: CGFloat = 1
    
    var body: some View {
        Canvas { context, size in
            let stepSize = size.width / CGFloat(divisions)
            
            var path = Path()
            
            for i in 1...divisions {
                let x = (CGFloat(i) * stepSize) - (stepSize / 2)
                path.move(to: CGPoint(x: x, y: 0))
                path.addLine(to: CGPoint(x: x, y: size.height))
            }
            
            let rowCount = Int(size.height / stepSize) + 1
            let yOffset = (size.height.truncatingRemainder(dividingBy: stepSize)) / 2
            
            for i in 1...rowCount {
                let y = (CGFloat(i) * stepSize) - (stepSize / 2) + yOffset
                path.move(to: CGPoint(x: 0, y: y))
                path.addLine(to: CGPoint(x: size.width, y: y))
            }
            
            context.stroke(
                path, with: .style(colorScheme == .light ? .quinary : .quaternary),
                lineWidth: lineWidth
            )
        }
    }
}
