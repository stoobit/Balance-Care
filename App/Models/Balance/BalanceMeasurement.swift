import SwiftUI

struct BalanceMeasurement: Codable {
    var roll: Double
    var pitch: Double
    var yaw: Double 
}

extension Array<BalanceMeasurement> {
    static func normalize(_ array: Self) -> Self {
        guard !array.isEmpty else { return array }
        
        let count = Double(array.count)
        let avgPitch = array.map { $0.pitch }.reduce(0, +) / count
        let avgRoll = array.map { $0.roll }.reduce(0, +) / count
        let avgYaw = array.map { $0.yaw }.reduce(0, +) / count
        
        let centered = array.map {
            BalanceMeasurement(
                roll: $0.roll - avgRoll,
                pitch: $0.pitch - avgPitch,
                yaw: $0.yaw - avgYaw
            )
        }
        
        let distances = centered.map { sqrt(pow($0.roll, 2) + pow($0.yaw, 2)) }
        guard let distance = distances.max(), distance > 0 else {
            return centered
        }
        
        let sizes = centered.map { abs($0.pitch) }
        guard let size = sizes.max(), size > 0 else {
            return centered
        }
        
        return centered.map {
            BalanceMeasurement(
                roll: $0.roll / distance,
                pitch: $0.pitch / size,
                yaw: $0.yaw / distance
            )
        }
    }
    
    static func smooth(_ array: Self, windowSize: Int = 10) -> Self {
        guard array.count > windowSize else { return array }
        var smoothed = array
        
        for i in 0..<array.count {
            let start = Swift.max(0, i - windowSize / 2)
            let end = Swift.min(array.count, i + windowSize / 2)
            let window = array[start..<end]
            
            let avgPitch = window.map { $0.pitch }.reduce(0, +) / Double(window.count)
            let avgRoll = window.map { $0.roll }.reduce(0, +) / Double(window.count)
            let avgYaw = window.map { $0.yaw }.reduce(0, +) / Double(window.count)
            
            smoothed[i] = BalanceMeasurement(roll: avgRoll, pitch: avgPitch, yaw: avgYaw)
        }
        
        return smoothed
    }
}
