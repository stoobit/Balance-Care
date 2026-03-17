import SwiftUI

extension TimerView {
    @ToolbarContentBuilder
    func StopwatchToolbar(width: Double) -> some ToolbarContent {
        ToolbarItem(placement: .cancellationAction) {
            Button("Close", systemImage: "xmark") {
                dismiss()
            }
        }
        
        ToolbarItem(placement: .bottomBar) {
            let enabled: Bool = (remaining != totalDuration) || isRunning
            
            Button(action: reset) {
                Text("Reset")
                    .font(.headline)
                    .foregroundStyle(enabled ? Color.secondaryAccentColor : Color.secondary)
                    .frame(width: max(0, width / 2 - 20), height: 40)
            }
            .buttonStyle(.glassProminent)
            .tint(Color.clear)
            .buttonSizing(.fitted)
            .disabled(!enabled)
            .frame(width: max(0, width / 2 - 20), height: 40)
        }
        
        ToolbarItem(placement: .bottomBar) {
            Button(action: {
                isRunning.toggle()
            }) {
                Text(!isRunning ? "Start" : "Stop")
                    .font(.headline)
                    .foregroundStyle(toggleTimerButtonColor(remaining: remaining))
                    .frame(width: max(0, width / 2 - 20), height: 40)
            }
            .buttonStyle(.glassProminent)
            .tint(Color.clear)
            .buttonSizing(.fitted)
            .disabled(max(0, remaining) == 0)
            .frame(width: max(0, width / 2 - 20), height: 40)
        }
    }
    
    func toggleTimerButtonColor(remaining: Double) -> Color {
        guard  max(0, remaining) != 0 else {
            return Color.secondary
        }
        
        return !isRunning ? Color.accentColor : Color.primary
    }
}
