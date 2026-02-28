import Foundation
import SwiftData

@Observable final class ActivityManager {
    let abbreviations = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    
    var currentDay: Day?
    var currentWeek: [Day] = []
    
    var labelOffset: Bool = false
    
    var balanceProgressRange: [Day] = []
    var exerciseFrequencyRange: [Day] = []
    
    var ratings: [Week] = []
    
    @discardableResult
    public func initialize(with context: ModelContext) -> Bool {
        do {
            if try isEmpty(context: context) {
                try initializeDays(with: context)
                try context.save()
            }
        } catch {
            if let error = error as? ActivityError,
               error == ActivityError.daysInitializationFailed
            {
                return true
            }
        }
        
        return false
    }
    
    public func loadCurrentWeek(from data: [Day]) {
        var calendar = Calendar.current
        calendar.firstWeekday = 2

        let now = Date.now

        guard let interval = calendar.dateInterval(of: .weekOfYear, for: now) else { return }
        let weekStart = interval.start

        guard let startIndex = data.firstIndex(where: { day in
            calendar.isDate(day.date, inSameDayAs: weekStart)
        }) else { return }

        let end = min(startIndex + 6, data.count - 1)
        self.currentWeek = Array(data[startIndex...end])
    }
    
    public func loadCurrentDay(using days: [Day]? = nil) {
        let calendar = Calendar.current
        currentDay = currentWeek.first { calendar.isDateInToday($0.date) }
    }
    
    public func loadExerciseFrequencyRange(from data: [Day]) {
        guard let now = currentDay?.date else { return }
        
        var calendar = Calendar.current
        calendar.firstWeekday = 2
        
        guard let nextMonth = calendar.date(byAdding: .month, value: 1, to: now),
              let startOfNextMonth = calendar.date(
                from: calendar.dateComponents([.year, .month], from: nextMonth)
              ),
              let lastDayOfMonth = calendar.date(
                byAdding: .day, value: -1, to: startOfNextMonth
              )
        else {
            return
        }
        
        let weekday = calendar.component(.weekday, from: lastDayOfMonth)
        guard var targetEndDate = calendar.date(
            byAdding: .day, value: -(weekday - 1), to: lastDayOfMonth
        ) else {
            return
        }

        labelOffset = false
        if let nextWeek = calendar.date(byAdding: .weekOfYear, value: 1, to: now),
           !calendar.isDate(now, equalTo: nextWeek, toGranularity: .month)
        {
            labelOffset = true
            
            targetEndDate = calendar.date(
                byAdding: .day, value: 28, to: targetEndDate
            ) ?? targetEndDate
        }
        
        guard let offset = data.firstIndex(where: {
            calendar.isDate($0.date, inSameDayAs: targetEndDate)
        }) else { return }
        
        let startIndex = offset - 111
        if startIndex >= 0 {
            self.exerciseFrequencyRange = Array(data[startIndex...offset])
        }
    }
    
    public func loadBalanceProgressRange(from data: [Day]) {
        var calendar = Calendar.current
        calendar.firstWeekday = 2
        
        guard let sunday = currentWeek.last?.date else {
            return
        }
        guard let index = data.firstIndex(where: {
            calendar.isDate($0.date, equalTo: sunday, toGranularity: .day)
        }) else { return }
        
        self.balanceProgressRange = Array(
            data[(index - 111)...index]
        )
    }
    
    public func loadAverageBalanceRatings(from data: [BalanceCheckWrapper]) {
        ratings.removeAll(keepingCapacity: true)
        
        for weekIndex in 0..<16 {
            let rawStart = weekIndex * 7
            
            let start = min(rawStart, balanceProgressRange.count)
            let end = min(rawStart + 7, balanceProgressRange.count)
            guard start < end else { continue }
            
            let days = balanceProgressRange[start..<end]
            let scores = data.compactMap { wrapper -> Int? in
                guard days.contains(where: {
                    Calendar.current.isDate(
                        $0.date, inSameDayAs: wrapper.balanceCheck.date
                    )
                }) else { return nil }
                
                return wrapper.balanceCheck.score.rawValue
            }
            
            guard scores.isEmpty else {
                let total = Double(scores.reduce(0, +))
                let count = Double(scores.count)
                
                ratings.append(score: total / count, using: days)
                continue
            }
            
            let last = ratings
                .reversed()
                .first(where: { $0.score != 0 })?.score
            ratings.append(score: last ?? 0, using: days)
        }
    }
    
    public func time(for date: Date = Date.now) -> Timestamp? {
        let hour = Calendar.current.component(.hour, from: date)
        
        if Date.morning.contains(hour) {
            return .morning
        }
        if Date.midday.contains(hour) {
            return .midday
        }
        if Date.afternoon.contains(hour) {
            return .afternoon
        }
        
        return nil
    }
    
    private func initializeDays(with context: ModelContext) throws {
        let calendar = Calendar.current
        let now = Date.now
        
        for count in -200...7300 {
            let date = calendar
                .date(byAdding: .day, value: count, to: now)
            
            guard let date else {
                throw ActivityError.daysInitializationFailed
            }
            
            let day = Day(for: date)
            context.insert(day)
        }
        
        try context.save()
    }
    
    private func isEmpty(context: ModelContext) throws -> Bool {
        let request = FetchDescriptor<Day>()
        let count = try context.fetchCount(request)
        
        return count == 0 ? true : false
    }
}

enum ActivityError: Error {
    case daysInitializationFailed
}

