import SwiftUI

struct BalanceProgressView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(BalanceManager.self) var manager
    
    @State private var value: CGFloat = 0.0
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            Capsule()
                .frame(height: 6)
                .overlay {
                    Capsule()
                        .foregroundStyle(color)
                        .frame(width: size.width)
                        .offset(x: offset(for: size.width))
                        .animation(.linear(duration: duration), value: value)
                }
                .clipShape(Capsule())
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .task(id: "play progress") {
            let id = manager.id
            value = 1
            
            Task {
                try? await Task.sleep(for: .seconds(duration))
                if id == manager.id {
                    manager.isPlaying = false
                }
            }
        }
    }
    
    private func offset(for width: CGFloat) -> CGFloat {
        return width * (value - 1)
    }
    
    private var color: Color {
        colorScheme == .dark ? .white : .black
    }
    
    private var duration: CGFloat {
        guard let count = manager.selection?.measurements.count else {
            return 0
        }
        
        return Double(count) * manager.duration
    }
}
