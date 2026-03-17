import SwiftUI
import SwiftData

struct ExerciseView: View {
    @Query private var images: [ImageModel]
    
    @Environment(ExerciseManager.self) private var exercise
    @Environment(BalanceManager.self) private var balance
    
    @State var showBalanceBoardView: Bool = false
    @State var selection: ExerciseModel?
    
    var body: some View {
        NavigationStack {
            List {
                if score != .none {
                    RecommendedView(selection: $selection)
                }
                
                Section("All Exercises") {
                    ForEach(exercise.exercises) { exercise in
                        Button(action: { selection = exercise.exercise }) {
                            ExerciseItemView(exercise: exercise)
                        }
                        .listRowInsets(EdgeInsets())
                        .navigationLinkIndicatorVisibility(.hidden)
                    }
                }
                
                BalanceBoardBadge()
            }
            .defaultViewStyle()
            .listRowSpacing(30)
            .navigationTitle("Exercises")
            .navigationDestination(item: $selection) { exercise in
                if let wrapper = self.exercise.exercises.first(where: {
                    $0.exercise.name == exercise.name
                }) {
                    ExerciseOverviewWrapper(exercise: exercise) {
                        ExerciseDetailView(exercise: wrapper)
                    }
                }
            }
            .sheet(isPresented: $showBalanceBoardView) {
                BalanceBoardView()
            }
        }
    }
    
    var score: BalanceScore {
        return balance.selection?.score ?? .none
    }
    
    @ViewBuilder
    func BalanceBoardBadge() -> some View {
        Section {
            Button(action: {
                showBalanceBoardView.toggle()
            }) {
                Label("Improve Your Balance Even Further", systemImage: "surfboard")
                    .foregroundStyle(Color.accentColor)
                    .labelIconToTitleSpacing(6)
                    .frame(maxWidth: .infinity)
                    .font(.caption)
            }
            .buttonStyle(.plain)
            .listRowBackground(Color.clear)
        }
        .listSectionSpacing(15)
    }
}
