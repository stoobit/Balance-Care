import Fluent
import Vapor

struct BalanceDataDTO: Content {
    var id: UUID?
    
    var userID: String?
    var measurements: [BalanceMeasurement]?
    
    func toModel() -> BalanceData {
        let model = BalanceData()
        model.id = self.id
        
        if let userID, let measurements {
            model.userID = userID
            model.measurements = measurements
        }
        
        return model
    }
}
