import Foundation

struct Week: Identifiable {
    let id = UUID()
    
    let date: Date
    let score: Double
}

extension [Week] {
    mutating func append(score: Double, using days: ArraySlice<Day>) {
        if let firstDate = days.first?.date {
            self.append(Week(date: firstDate, score: score))
        }
    }
}
