import SwiftUI
import SwiftData

struct RecommendedView: View {
    @Environment(ExerciseManager.self) var exercise
    @Environment(BalanceManager.self) var balance
    
    @Binding var selection: ExerciseModel?
    
    @Query(sort: [
        SortDescriptor(\BalanceCheckWrapper.balanceCheck.date, order: .reverse)
    ]) var wrappers: [BalanceCheckWrapper]
    
    var body: some View {
        Section("Suggestions") {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(recommendations) { recommendation in
                        Pill(for: recommendation)
                    }
                }
            }
            .scrollIndicators(.hidden)
            .listRowInsets(EdgeInsets())
            .listRowBackground(Color.clear)
        }
    }
    
    @ViewBuilder
    func Pill(for exercise: ExerciseModel) -> some View {
        Button(action: { selection = exercise }) {
            HStack(spacing: 10) {
                Circle()
                    .foregroundStyle(exercise.difficulty.color)
                    .frame(width: 7, height: 7)
                
                Text(exercise.name)
                    .font(.headline)
            }
            .padding()
            .background(Color("DefaultListRowColor"))
            .clipShape(.capsule)
        }
        .buttonStyle(.plain)
    }
    
    private var recommendations: [ExerciseModel] {
        guard let score = wrappers.first?.balanceCheck.score else {
            return .empty
        }
        
        return score
            .recommendations(using: exercise.exercises)
            .map { $0.exercise }
    }
}
