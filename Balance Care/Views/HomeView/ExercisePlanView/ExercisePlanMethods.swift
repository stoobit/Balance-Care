import SwiftUI
import TipKit

extension ExercisePlanView {
    func setAction() {
        defer {
            if currentAction == .waiting {
                setFooter()
            }
        }
        
        if activity.currentWeek.balanceChecks().isEmpty {
            currentAction = .balanceCheck
            return
        }
        
        guard let day = activity.currentDay else {
            currentAction = .waiting
            return
        }
        
        let calendar = Calendar.current
        if calendar.component(.weekday, from: Date()) == 2, day.check == nil {
            currentAction = .balanceCheck
            return
        }
        
        let time = activity.time()
        
        if let check = day.check, time == activity.time(for: check.date) {
            currentAction = .waiting
            return
        }
        if day.exercises.times.contains(time) == false, let action = time?.action {
            currentAction = action
            return
        }
        
        currentAction = .waiting
    }
    
    func setFooter() {
        guard
            let action = activity.time()?.action,
            let sunday = activity.currentWeek.last?.date
        else {
            infoText = Text(verbatim: .empty)
            return
        }
        
        let isSunday = Calendar.current.isDate(
            .now, equalTo: sunday, toGranularity: .day
        )
        
        let isCheck = action == .afternoonExercise && isSunday
        let type: ActivityType = isCheck ? .balanceCheck : .exercise
        
        let time = action.next.timeDescription
        infoText = if type == .exercise {
            Text(
                """
                Your next exercise is scheduled for \(time).
                """
            )
        } else {
            Text(
                """
                Your next Balance Check is scheduled for \(time).
                """
            )
        }
    }
    
    func onTimer(date: Date) {
        let calendar = Calendar.current
        let minute = calendar.component(.minute, from: date)
        let second = calendar.component(.second, from: date)
        
        guard minute == 0 && second == 0 else { return }
        setAction()
    }
    
    func action() {
        tip.invalidate(reason: .actionPerformed)
        
        switch currentAction {
        case .balanceCheck:
            showCheck = true
        default:
            showRecommendedAction()
        }
    }
    
    func showRecommendedAction() {
        guard let score = balanceChecks.first?.balanceCheck.score else {
            return
        }
        
        let recommendedExercises: [ExerciseModel] = score
            .recommendations(using: exercise.exercises)
            .map { $0.exercise }
        
        if score == .veryStable {
            selectedExercise = recommendedExercises.randomElement()
            return
        }
        
        let currentExercises: [ExerciseModel] = activity.currentWeek
            .flatMap(\.exercises)
        
        for recommendedExercise in recommendedExercises {
            let count = currentExercises.lazy
                .filter({ $0.id == recommendedExercise.id })
                .count
            
            if count < 2 {
                selectedExercise = recommendedExercise
                return
            }
        }
        
        selectedExercise = recommendedExercises.randomElement()
    }
    
    func color(for day: Day) -> Color {
        let isToday = Calendar.current.isDateInToday(day.date)
        return isToday ? Color.primary : Color.secondary
    }
    
    func color(for timestamp: Timestamp, at day: Day) -> Color {
        if let check = day.check, activity.time(for: check.date) == timestamp {
            return Color.secondaryAccentColor
        }
        
        let exerciseDone = day.exercises.times.contains(timestamp)
        return exerciseDone ? Color.accentColor : Color.secondary
    }
    
    func abbreviation(for day: Int) -> String {
        return activity.abbreviations.indices.contains(day) ? activity.abbreviations[day] : ""
    }
    
    func accessibilitySize() -> DynamicTypeSize {
        if [.xSmall, .small, .medium, .large].contains(typeSize) {
            return typeSize
        }
        
        return .xLarge
    }
}
