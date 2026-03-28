import SwiftUI
import Charts

struct ImprovementChart: View {
    @Environment(ActivityManager.self) private var activity
    @Environment(\.dynamicTypeSize) private var typeSize
    
    @State private var showInfo: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text("Balance Progress")
                        .font(.headline)
                    
                    Text("Average Score / Week")
                        .accessibilityLabel(Text("Average Score per Week"))
                        .foregroundStyle(Color.secondary)
                        .font(.caption)
                }
                
                Spacer()
                
                Button("Info", systemImage: "info.circle") {
                    showInfo.toggle()
                }
                .foregroundStyle(Color.accentColor)
                .labelStyle(.iconOnly)
                .buttonStyle(.plain)
            }
            .sheet(isPresented: $showInfo) {
                AboutSheetView()
            }
            
            Chart(activity.ratings) { value in
                LineMark(
                    x: .value("Week", value.date),
                    y: .value("Average Score", value.score)
                )
                .interpolationMethod(.monotone)
                
                PointMark(
                    x: .value("Week", value.date),
                    y: .value("Average Score", value.score)
                )
                .symbolSize(30)
            }
            .chartYAxis { AxisMarks(values: [0, 1, 2, 3, 4]) }
            .chartYScale(domain: [0, 4.1])
            .frame(height: 210)
        }
        .dynamicTypeSize(accessibilitySize())
        .padding(.vertical, 3)
    }
    
    func accessibilitySize() -> DynamicTypeSize {
        if [.xSmall, .small, .medium, .large, .xLarge].contains(typeSize) {
            return typeSize
        }
        
        return .xxLarge
    }
}

