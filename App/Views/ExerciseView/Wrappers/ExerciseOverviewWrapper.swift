import SwiftUI

import Analytics

struct ExerciseOverviewWrapper<Content: View>: View {
    @State var confirmationDialog: Bool = false
    
    @Environment(ActivityManager.self) var activity
    @Environment(Analytics.self) var analytics
    
    var exercise: ExerciseModel? = nil
    @ViewBuilder var content: Content
    
    var body: some View {
        NavigationStack {
            content
                .toolbar {
                    if let exercise {
                        ToolbarItem(placement: .primaryAction) {
                            Button("Mark as Completed", systemImage: "checkmark") {
                                confirmationDialog = true
                            }
                            .foregroundStyle(Color.black)
                            .buttonStyle(.glassProminent)
                            .confirmationDialog(
                                "Add Extra Exercise",
                                isPresented: $confirmationDialog,
                                actions: {
                                    Button("Mark as Completed", role: .confirm) {
                                        markAsCompleted(exercise: exercise)
                                    }
                                },
                                message: {
                                    Text("Do you want to mark this exercise as completed outside of your scheduled plan?")
                                }
                            )
                        }
                    }
                }
        }
    }
    
    func markAsCompleted(exercise: ExerciseModel) {
        activity.currentDay?.exercises.append(exercise)
        
        analytics.track("Exercise", properties: [
            "name": exercise.name
        ])
        
        confirmationDialog = false
    }
}
