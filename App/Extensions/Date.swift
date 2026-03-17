import Foundation

extension Date {
    var string: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short

        return formatter.string(from: self)
    }
    
    static var initial: Date {
        Date(timeIntervalSince1970: 0)
    }
    
    static func time(hour: Int, minute: Int = 0) -> Date {
        let date = Calendar.current
            .date(bySettingHour: hour, minute: minute, second: 0, of: .initial)
        
        return date ?? .initial
    }
    
    // Times of Day
    static var morning: Range<Int> {
        return 00..<11
    }
    
    static var midday: Range<Int> {
        return 11..<15
    }
    
    static var afternoon: Range<Int> {
        return 15..<23
    }
}
