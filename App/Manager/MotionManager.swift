import Foundation
import CoreMotion

@Observable final class MotionManager {
    // Balance Check
    var balanceCheck: BalanceCheckModel = BalanceCheckModel()
    
    // Motion
    private let motionProvider = CMMotionManager()
    typealias Interval = Double
    
    func startMeasuring(with interval: Interval) {
        balanceCheck = BalanceCheckModel()
        
        motionProvider.deviceMotionUpdateInterval = interval
        motionProvider.startDeviceMotionUpdates(to: .main) { [weak self] data, _ in
            if (self?.balanceCheck.measurements.count ?? 0) < 2000 {
                guard let motion = data?.attitude else { return }
                let measurement = BalanceMeasurement(
                    roll: motion.roll, pitch: motion.pitch, yaw: motion.yaw
                )
                
                self?.balanceCheck.measurements.append(measurement)
            }
        }
    }
    
    func stopMeasuring() {
        if motionProvider.isDeviceMotionActive {
            motionProvider.stopDeviceMotionUpdates()
        }
    }
}
