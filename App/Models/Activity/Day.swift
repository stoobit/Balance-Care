import Foundation
import SwiftData

@Model final class Day: Identifiable {
    @Attribute(.unique) var id = UUID()
    
    var date: Date
    init(for date: Date) {
        self.date = date
    }
    
    var check: BalanceCheckModel?
    var exercises: [ExerciseModel] = []
}

extension [Day] {
    func balanceChecks() -> [BalanceCheckModel] {
        .init(self.compactMap(\.check))
    }
}
