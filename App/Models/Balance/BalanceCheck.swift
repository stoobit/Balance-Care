import Foundation

nonisolated struct BalanceCheckModel: Identifiable, Codable, Sendable {
    var id: UUID = UUID()
    var user: UUID? = UUID()
    
    var score: BalanceScore = .none
    var progress: BalanceProgress? = nil
    
    var date: Date = Date()
    var measurements: [BalanceMeasurement] = []
}
