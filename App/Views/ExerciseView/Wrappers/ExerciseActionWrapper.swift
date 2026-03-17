import SwiftUI

import Analytics

struct ExerciseActionWrapper<Content: View>: View {
    @Environment(\.dismiss) private var dismiss
    @State private var confirmationDialog: Bool = false
    
    @Environment(ActivityManager.self) var activity
    @Environment(Analytics.self) var analytics
    
    var exercise: ExerciseModel? = nil
    
    @ViewBuilder
    var content: Content
    
    var body: some View {
        NavigationStack {
            content
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Close", systemImage: "xmark") {
                            if let _ = exercise {
                                confirmationDialog = true
                            } else {
                                dismiss()
                            }
                        }
                        .confirmationDialog("Cancel Exercise", isPresented: $confirmationDialog, actions: {
                            Button("Cancel Exercise", role: .destructive) {
                                dismiss()
                                confirmationDialog = false
                            }
                            
                        }, message: {
                            Text("Are you sure you want to cancel this exercise?")
                        })
                    }
                    
                    if let exercise {
                        ToolbarItem(placement: .primaryAction) {
                            Button("Mark as Completed", systemImage: "checkmark") {
                                markAsCompleted(exercise: exercise)
                            }
                            .foregroundStyle(Color.black)
                            .buttonStyle(.glassProminent)
                        }
                    }
                }
        }
    }
    
    func markAsCompleted(exercise: ExerciseModel) {
        guard let time = activity.time() else {
            return
        }
        
        activity.currentDay?.exercises.append(
            ExerciseModel(exercise: exercise, time: time)
        )
        
        analytics.track("Exercise", properties: [
            "name": exercise.name
        ])
        
        dismiss()
    }
}
