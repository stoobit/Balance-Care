import Fluent
import struct Foundation.UUID

final class BalanceData: Model, @unchecked Sendable {
    static let schema = "balancedata"
    
    @ID(key: .id)
    var id: UUID?
    
    init() {  }
    
    @Field(key: "userID")
    var userID: String
    
    @Field(key: "measurements")
    var measurements: [BalanceMeasurement]
    
    func toDTO() -> BalanceDataDTO {
        .init(id: self.id, userID: self.userID, measurements: self.measurements)
    }
}

struct BalanceMeasurement: Codable {
    var roll: Double
    var pitch: Double
    var yaw: Double
}
