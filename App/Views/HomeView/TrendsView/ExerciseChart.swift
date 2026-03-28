import SwiftUI

struct ExerciseChart: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dynamicTypeSize) private var typeSize
    
    @Environment(ActivityManager.self) private var activity
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                VStack(alignment: .leading) {
                    Text("Exercise Frequency")
                        .font(.headline)
                    
                    Text("Workouts / Day")
                        .accessibilityLabel(Text("Workouts per Day"))
                        .foregroundStyle(Color.secondary)
                        .font(.caption)
                }
                
                Spacer()
            }
            
            HStack {
                VStack {
                    ForEach(0..<7) { day in
                        Text(days[day])
                            .font(.footnote)
                            .monospaced()
                            .frame(height: 11)
                            .foregroundStyle(
                                day % 2 == 0 ? Color.primary : Color.clear
                            )
                    }
                }
                .frame(maxHeight: .infinity, alignment: .bottom)
                
                ForEach(0..<4) { month in
                    VStack(alignment: .leading) {
                        Text(months[month])
                            .font(.footnote)
                            .monospaced()
                        
                        HStack {
                            ForEach(0..<4) { week in
                                VStack(alignment: .trailing) {
                                    ForEach(0..<7) { day in
                                        let value = self.day(month, week, day)
                                        
                                        RoundedRectangle(cornerRadius: 2.5)
                                            .foregroundStyle(color(for: value))
                                            .frame(width: 11, height: 11)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity)
            
            Capsule()
                .foregroundStyle(Color.secondary.opacity(0.2))
                .frame(width: 45, height: 3)
            
            HStack {
                Text("0")
                    .frame(height: 11)
                
                ForEach(colors, id: \.self) { color in
                    RoundedRectangle(cornerRadius: 2.5)
                        .frame(width: 11, height: 11)
                        .foregroundStyle(color)
                }
                
                Text("3")
                    .frame(height: 11)
            }
            .font(.body)
        }
        .dynamicTypeSize(accessibilitySize())
        .padding(.vertical, 3)
    }
    
    let days: [String] = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    var colors: [Color] {
        [
            defaultColor(),
            Color.accentColor.opacity(0.2),
            Color.accentColor.opacity(0.6),
            Color.accentColor.opacity(1),
        ]
    }
    
    func day(_ month: Int, _ week: Int, _ day: Int) -> Day? {
        let index = month * 28 + week * 7 + day
        return activity.exerciseFrequencyRange.indices.contains(index) ? activity.exerciseFrequencyRange[index] : nil
    }
    
    func color(for day: Day?) -> Color {
        guard let day else {
            return defaultColor()
        }
        
        let count = day.exercises.count + (day.check == nil ? 0 : 1)
        let index = count > 3 ? 3 : count
        return colors[index]
    }
    
    func defaultColor() -> Color {
        colorScheme == .light ? Color(.secondarySystemBackground) : Color("SheetListRowColor")
    }

    var months: [String] {
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"

        var months: [String] = []
        let offset = activity.labelOffset ? 1 : 0

        for i in 0..<4 {
            if let date = calendar.date(
                byAdding: .month, value: (-i + offset), to: Date()
            ) {
                months.append(dateFormatter.string(from: date))
            }
        }

        months.reverse()
        return months
    }
    
    func accessibilitySize() -> DynamicTypeSize {
        if [.xSmall, .small, .medium, .large, .xLarge].contains(typeSize) {
            return typeSize
        }
        
        return .xxLarge
    }
}
