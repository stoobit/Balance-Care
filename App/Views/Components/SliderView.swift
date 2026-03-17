import SwiftUI

struct SliderView: View {
    @Environment(\.dynamicTypeSize) private var typeSize
    @Environment(\.colorSchemeContrast) var contrast
    
    @State private var offsetX: CGFloat = 0
    
    var title: String? = nil
    var image: String? = nil
    
    var action: () -> Void
    
    var body: some View {
        GeometryReader { geometry in
            let size = geometry.size
            let knobSize = size.height
            let maxLimit = size.width - knobSize - 12
            let progress: CGFloat = offsetX / maxLimit
            
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(.quinary)
                
                HStack(spacing: 0) {
                    KnobView(size, progress: progress, maxLimit: maxLimit)
                        .zIndex(1)
                    
                    TextView(size, progress: progress)
                }
            }
            .dynamicTypeSize(accessibilitySize())
        }
        .frame(height: 65)
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 21)
    }
    
    @ViewBuilder
    func KnobView(
        _ size: CGSize, progress: CGFloat, maxLimit: CGFloat
    ) -> some View {
        Image(systemName: image ?? "xmark")
            .foregroundStyle(.primary)
            .font(.title3.bold())
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .clipShape(.circle)
            .glassEffect(.clear.interactive())
            .frame(width: size.height, height: size.height)
            .padding(6)
            .contentShape(.circle)
            .offset(x: offsetX)
            .gesture(
                DragGesture()
                    .onChanged({ value in
                        offsetX = min(
                            max(value.translation.width, 0), maxLimit
                        )
                    })
                    .onEnded({ value in
                        if offsetX == maxLimit {
                            action()
                            
                            withAnimation(.smooth) {
                               offsetX = 0
                            }
                        } else {
                            withAnimation(.smooth) {
                               offsetX = 0
                            }
                        }
                    })
            )
        
    }
    
    @ViewBuilder
    func TextView(_ size: CGSize, progress: CGFloat) -> some View {
        Text("Swipe to \(title ?? "Cancel")")
            .foregroundStyle(contrast == .increased ? Color.primary : .secondary)
            .fontWeight(.medium)
            .frame(maxWidth: .infinity)
            .padding(.trailing, (size.height / 2) + 6)
            .mask {
                Rectangle()
                    .scale(x: 1 - progress, anchor: .trailing)
            }
            .frame(height: size.height)
    }
    
    func accessibilitySize() -> DynamicTypeSize {
        if [.xSmall, .small, .medium, .large, .xxLarge].contains(typeSize) {
            return typeSize
        }
        
        return .xxxLarge
    }
}
