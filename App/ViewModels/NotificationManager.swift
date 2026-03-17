import Foundation
import UserNotifications

@Observable final class NotificationManager {
    static func authorizationStatus() async -> UNAuthorizationStatus {
        return await UNUserNotificationCenter.current()
            .notificationSettings().authorizationStatus
    }
    
    static func askPermission() async {
        _ = try? await UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .badge, .sound])
    }
    
    static func setNotifications(_ morning: Date, _ midday: Date, _ afternoon: Date) {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        // Exercises
        schedule(.exercise, date: morning, weekdays: [3, 4, 5, 6, 7, 1])
        schedule(.exercise, date: midday)
        schedule(.exercise, date: afternoon)
        
        // Balance Check
        schedule(.balanceCheck, date: morning, weekdays: [2])
    }
    
    static func schedule(
        _ content: UNMutableNotificationContent,
        date: Date, weekdays: [Int]? = nil
    ) {
        let center = UNUserNotificationCenter.current()
        
        if let weekdays = weekdays {
            for day in weekdays {
                let trigger = trigger(date: date, day: day)
                let request = UNNotificationRequest(
                    identifier: UUID().uuidString, content: content, trigger: trigger
                )
                
                center.add(request)
            }
        } else {
            let trigger = trigger(date: date)
            let request = UNNotificationRequest(
                identifier: UUID().uuidString, content: content, trigger: trigger
            )
            
            center.add(request)
        }
    }
    
    static func trigger(date: Date, day: Int? = nil) -> UNCalendarNotificationTrigger {
        var components = DateComponents()
        components.hour = Calendar.current.component(.hour, from: date)
        components.minute = Calendar.current.component(.minute, from: date)
        
        if let day {
            components.weekday = day
        }
        
        return UNCalendarNotificationTrigger(
            dateMatching: components, repeats: true
        )
    }
    
    static func removeDeliveredNotifications() {
        let center = UNUserNotificationCenter.current()
        center.removeAllDeliveredNotifications()
    }
}

extension UNMutableNotificationContent {
    static var exercise: UNMutableNotificationContent {
        let content = UNMutableNotificationContent(
            title: "Balance Exercise",
            body: "Time to practice your balance."
        )
        
        content.interruptionLevel = .active
        return content
    }
    
    static var balanceCheck: UNMutableNotificationContent {
        let content = UNMutableNotificationContent(
            title: "Balance Check",
            body: "Let’s see how your balance has improved this week."
        )
        
        content.interruptionLevel = .active
        return content
    }
    
    convenience init(title: String, body: String) {
        self.init()
        
        self.title = title
        self.body = body
        self.sound = .default
    }
}

#if DEBUG
extension NotificationManager {
    static func pendingNotifications() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            print("--- Pending Notifications: \(requests.count) ---")
            
            for request in requests {
                print("ID: \(request.identifier)")
                print("Title: \(request.content.title)")
                print("Body: \(request.content.body)")
                
                if let trigger = request.trigger {
                    print("Trigger: \(trigger)")
                    
                    if let calendarTrigger = trigger as? UNCalendarNotificationTrigger {
                        print("  - Type: Calendar")
                        print("  - Next Trigger Date: \(calendarTrigger.nextTriggerDate()?.description ?? "N/A")")
                    } else if let intervalTrigger = trigger as? UNTimeIntervalNotificationTrigger {
                        print("  - Type: Time Interval")
                        print("  - Next Trigger Date: \(intervalTrigger.nextTriggerDate()?.description ?? "N/A")")
                    }
                }
                print("---------------------------------")
            }
        }
    }
}
#endif
