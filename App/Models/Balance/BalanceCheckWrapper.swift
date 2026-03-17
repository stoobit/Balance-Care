import SwiftData

@Model final class BalanceCheckWrapper {
    init(for balanceCheck: BalanceCheckModel) {
        self.balanceCheck = balanceCheck
    }
    
    var balanceCheck: BalanceCheckModel
    var state: BalanceUploadState?
}

extension [BalanceCheckWrapper] {
    func progress(for score: BalanceScore) -> BalanceProgress {
        let scores: [Double] = self.map({
            return Double($0.balanceCheck.score.rawValue)
        })
        
        guard scores.isEmpty else {
            let total: Double = scores.reduce(0, +)
            let count: Double = Double(scores.count)
            
            return .progress(score: score, average: total / count)
        }
        
        return .improvement
    }
}
