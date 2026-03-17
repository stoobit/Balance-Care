import Foundation
import FoundationModels

extension AppleIntelligence {
    // What should the LLM do?
    func response(for date: Date, activity: ActivityManager, check: BalanceCheckModel?) async -> String {
        guard let check else {
            return .empty
        }
        
        let days = activity.currentWeek
            .filter({ $0.date >= date })
        
        guard days.isEmpty == false else {
            return .empty
        }
        
        let prompt = Prompt {
            if days.flatMap(\.exercises).count > 0 {
                // SECTION 1: THE DATA
                for (index, day) in days.enumerated() {
                    let dayNumber = index + 1
                    let count = day.exercises.count
                    
                    if index == 0 {
                        "(Oldest) Day \(dayNumber): \(count) sessions"
                    } else if index == days.count - 1 {
                        "(Recent) Day \(dayNumber): \(count) sessions"
                    } else {
                        "Day \(dayNumber): \(count) sessions"
                    }
                }
                
                // SECTION 2: THE CONTEXT
                """
                [CURRENT STATUS]
                Balance Score: \(check.score.title)
                Trend: \(check.progress?.accessibilityTitle, default: "-")
                """
                
                // SECTION 3: THE RULES
                """
                [TRAINING STANDARDS]
                - Ideal: 3+ sessions per day.
                - Acceptable: 2 sessions per day.
                - Insufficient: 0-1 sessions per day.
                """
                
                // SECTION 4: THE TASK
                """
                Based on the logs above, provide the feedback summary. Remember: No digits allowed.
                """
            } else {
                """
                [CURRENT STATUS]
                Balance Score: \(check.score.title)
                Training History: None (First use)
                """
                
                // SECTION 2: THE TASK
                """
                The user is starting their balance training journey today.
                Write a warm, welcoming 1-2 sentence summary.
                
                Guidelines:
                - Do NOT mention missed training or past days.
                - Interpret their 'Balance Score' as their starting baseline.
                - If the score is low: Reassure them that regular practice will help stabilize it.
                - If the score is high: Encourage them to train to maintain this great condition.
                - Remember: No digits allowed.
                """
            }
        }
        
        return await respond(to: prompt).trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
