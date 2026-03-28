import SwiftUI

struct BalanceGraphicView: View {
    @Environment(BalanceManager.self) var manager
    var color: Color
    
    struct AnimationValues {
        var position: CGPoint = .zero
        var size: CGSize = .zero
    }
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            let width: CGFloat = 20
            
            let diameter = size.width * 0.75
            
            ZStack {
                Circle()
                    .opacity(0)
                    .glassEffect(.clear, in: Circle().stroke(lineWidth: width))
                    .frame(width: diameter, height: diameter)
                
                Circle()
                    .opacity(0)
                    .glassEffect(.clear.tint(color), in: Circle())
                    .frame(width: 50, height: 50)
                    .keyframeAnimator(
                        initialValue: AnimationValues(),
                        trigger: manager.isPlaying
                    ) { content, value in
                        
                        content
                            .offset(x: value.position.x, y: value.position.y)
                        
                    } keyframes: { value in
                        KeyframeTrack(\.position) {
                            for keyframe in keyframes(with: diameter) {
                                keyframe
                            }
                            
                            CubicKeyframe(.zero, duration: 0.3)
                        }
                    }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func keyframes(with diameter: CGFloat) -> [CubicKeyframe<CGPoint>] {
        var keyframes: [CubicKeyframe<CGPoint>] = .empty
        let coordinates = coordinates(with: diameter)
        
        if coordinates.isEmpty == false {
            keyframes.append(CubicKeyframe(coordinates[0], duration: 0.3))
            
            for coordinate in coordinates[1...] {
                let keyframe = CubicKeyframe(coordinate, duration: manager.duration)
                keyframes.append(keyframe)
            }
        }
        
        return keyframes
    }
    
    private func coordinates(with diameter: CGFloat) -> [CGPoint] {
        guard manager.isPlaying else {
            return .empty
        }
        
        guard let selection = manager.selection else {
            return .empty
        }
        
        return selection.measurements.map {
            calculate(x: $0.roll, y: $0.pitch, diameter: diameter)
        }
    }
    
    private func calculate(x: CGFloat, y: CGFloat, diameter: CGFloat) -> CGPoint {
        let width: CGFloat = 50/2 - 20/2
        let offset: CGFloat = diameter/2 - width - 5
        
        return CGPoint(x: offset * x, y: offset * y)
    }
}
