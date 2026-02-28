import SwiftUI

struct ExerciseOverviewWrapper<Content: View>: View {
    @Environment(ActivityManager.self) var activity
    @State var confirmationDialog: Bool = false
    
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
        confirmationDialog = false
    }
}
