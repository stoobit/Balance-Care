import SwiftUI

struct Triangle: IterableShape {
    var offset: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let start = CGPoint(x: rect.maxX, y: rect.maxY * 0.8)
        
        path.move(to: start)
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: start)
        
        path.closeSubpath()
        return path
    }
}

struct Trapezoid: IterableShape {
    var offset: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let start = CGPoint(
            x: rect.maxX,
            y: rect.maxY * (1 - 0.2 * offset)
        )
        
        path.move(to: start)
        path.addLine(to: CGPoint(
            x: rect.minX,
            y: rect.maxY * (1.2 - 0.2 * offset) - 2
        ))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: start)
        
        path.closeSubpath()
        return path
    }
}
