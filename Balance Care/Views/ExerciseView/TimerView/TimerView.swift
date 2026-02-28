import SwiftUI
import Combine

struct TimerView: View {
    @Environment(\.dismiss) var dismiss
    @State var alarm = AlarmManager()
    
    @State var remaining: Double
    @State var isRunning: Bool = false
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let totalDuration: Double
    
    init(seconds: Double) {
        self.totalDuration = seconds
        _remaining = State(initialValue: seconds)
    }
    
    var body: some View {
        NavigationStack {
            GeometryReader { proxy in
                Text(remaining, format: .timerCountdown)
                    .font(.system(size: 200))
                    .fontWidth(.compressed)
                    .fontWeight(.bold)
                    .monospacedDigit()
                    .contentTransition(.numericText())
                    .animation(.default, value: remaining)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .dynamicTypeSize(.medium)
                    .toolbar {
                        let width = proxy.size.width - 60
                        return StopwatchToolbar(width: width)
                    }
            }
        }
        .onReceive(timer, perform: onReceive(timer:))
        .onChange(of: remaining) { alarm._playAlarm(remaining) }
        .onAppear(perform: alarm.requestAuthorization)
        .interactiveDismissDisabled()
        .presentationDetents([.fraction(0.45)])
        .presentationBackgroundInteraction(
            .enabled(upThrough: .fraction(0.45))
        )
    }
    
    func onReceive(timer: Date) {
        if isRunning && remaining != 0 {
            remaining -= 1
        }
    }
    
    func reset() {
        isRunning = false
        remaining = totalDuration
    }
}

#Preview {
    @Previewable @State var isPresented: Bool = true
    
    NavigationStack {
        ExerciseDetailView(exercise: ExerciseManager().exercises[0])
            .sheet(isPresented: $isPresented) {
                TimerView(seconds: 20)
            }
    }
}
