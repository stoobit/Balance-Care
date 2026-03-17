import Foundation

struct TimerCountdownFormatStyle: FormatStyle {
    func format(_ value: Double) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        
        return String(formatter.string(from: value)?.dropFirst() ?? "")
    }
}

extension FormatStyle where Self == TimerCountdownFormatStyle {
    static var timerCountdown: TimerCountdownFormatStyle { TimerCountdownFormatStyle() }
}
