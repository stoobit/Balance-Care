import Combine
import SwiftUI
import SwiftData
import TipKit

struct ExercisePlanView: View {
    @Environment(ActivityManager.self) var activity
    @Environment(ExerciseManager.self) var exercise
    
    @Environment(\.colorSchemeContrast) var contrast
    @Environment(\.dynamicTypeSize) var typeSize
    @Environment(\.scenePhase) var scenePhase
    
    @Namespace var namespace
    var balanceChecks: [BalanceCheckWrapper]
    
    @State var selectedExercise: ExerciseModel?
    @State var currentAction: ActionType = .waiting
    @State var showCheck: Bool = false

    @State var showInfo: Bool = false
    @State var infoText: Text = Text(verbatim: .empty)
    
    let tip = BalanceCheckTip()
    
    let timer = Timer
        .publish(every: 60, on: .main, in: .common)
        .autoconnect()
    
    var body: some View {
        let width: CGFloat = 7
        
        Section {
            HStack {
                ForEach(0..<activity.currentWeek.count, id: \.self) { index in
                    let day = activity.currentWeek[index]

                    VStack(spacing: 15) {
                        HStack(spacing: 4) {
                            ForEach(Timestamp.allCases, id: \.self) { timestamp in
                                let color = color(for: timestamp, at: day)
                                Circle()
                                    .foregroundStyle(color)
                                    .frame(width: width, height: width)
                                    .opacity(contrast == .increased && color == .secondary ? 0.5 : 1)
                            }
                        }
                        
                        Text(abbreviation(for: index))
                            .font(.body)
                            .dynamicTypeSize(accessibilitySize())
                            .fontWeight(.medium)
                            .foregroundStyle(color(for: day))
                            .frame(maxWidth: .infinity)
                    }
                    .padding(.top, 10)
                }
            }
            .onChange(of: activity.currentDay?.exercises, setAction)
            .onChange(of: balanceChecks, setAction)
            .onChange(of: scenePhase, setAction)
            .onReceive(timer, perform: onTimer)
            .onAppear(perform: setAction)
            .fullScreenCover(item: $selectedExercise) { exercise in
                if let wrapper = self.exercise.exercises.first(where: {
                    $0.exercise.name == exercise.name
                }) {
                    ExerciseActionWrapper(exercise: exercise) {
                        ExerciseDetailView(exercise: wrapper)
                    }
                }
            }
            .fullScreenCover(isPresented: $showCheck) {
                BalanceCheckContainer(isPresented: $showCheck, context: .weekly)
            }
        } header: {
            Text("Exercise Plan")
        } footer: {
            if currentAction == .waiting, infoText != Text(verbatim: .empty) {
                infoText
            }
        }
        
        if currentAction != .waiting {
            Section {
                ActionButton(type: currentAction, action: action)
                    .popoverTip(tip, arrowEdge: .top)
            }
            .listSectionSpacing(15)
        }
    }
}
