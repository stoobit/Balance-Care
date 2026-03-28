import SwiftUI

struct Picker: View {
    var time: Timestamp
    var label: String
    
    @Binding var selection: Date
    
    var body: some View {
        DatePicker(
            selection: $selection, in: self.range(for: time),
            displayedComponents: .hourAndMinute
        ) {
            Label {
                VStack(alignment: .leading) {
                    Text(time.title.capitalized)
                    Text("until \(time.range.upperBound):00 \(label)")
                        .font(.caption)
                        .foregroundStyle(Color.secondary)
                }
            } icon: {
                Image(systemName: "bell.badge")
            }
        }
    }
    
    private func range(for timestamp: Timestamp) -> ClosedRange<Date> {
        switch timestamp {
        case .morning:
            let lower = Date.time(hour: Date.morning.lowerBound)
            let upper = Date.time(hour: Date.morning.upperBound - 1, minute: 30)
            
            return lower...upper
        case .midday:
            let lower = Date.time(hour: Date.midday.lowerBound)
            let upper = Date.time(hour: Date.midday.upperBound - 1, minute: 30)
            
            return lower...upper
        case .afternoon:
            let lower = Date.time(hour: Date.afternoon.lowerBound)
            let upper = Date.time(hour: Date.afternoon.upperBound)
            
            return lower...upper
        }
    }
}
