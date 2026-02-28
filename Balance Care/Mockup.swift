import SwiftUI
import SwiftData

import Analytics

#Preview("Overview") {
    createPreview {
        let view = ContentView(selection: .home, initializeDays: false)
        view.onboarding.showSheet = false
        
        return view
            .delayed { view in
                view.activity.currentAction = .balanceCheck
            }
    }
}

extension ContentView {
    @ViewBuilder
    func delayed(perform: @escaping (ContentView) -> Void) -> some View {
        self.onAppear {
            Task { @MainActor in
                try await Task.sleep(for: .seconds(0.01))
                perform(self)
            }
        }
    }
}

@MainActor
fileprivate func createPreview<Content: View>(view: () -> Content) -> some View {
    let container: ModelContainer = {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(
            for: BalanceCheckWrapper.self, Day.self, ImageModel.self,
            configurations: config
        )
        
        do {
            try container.mainContext.delete(model: Day.self)
            
            for week in 0...20 {
                var model = BalanceCheckModel(score: .somewhatStable)
                
                switch week {
                case 0:
                    model.score = .veryStable
                case 1, 2, 3, 4, 7, 8, 9:
                    model.score = .stable
                case 5, 6, 10, 11, 12, 13:
                    model.score = .somewhatStable
                default:
                    model.score = .unstable
                }
                
                if let date = Calendar.current.date(
                    byAdding: .weekOfYear, value: -week, to: .now
                ) { model.date = date }
                
                if let data = example.data(using: .utf8) {
                    let measurements = try JSONDecoder()
                        .decode([BalanceMeasurement].self, from: data)
                    
                    model.measurements = measurements
                }
                
                container.mainContext.insert(BalanceCheckWrapper(for: model))
            }
            
            let calendar = Calendar.current
            let now = Date.now
            for count in -200...7300 {
                let date = calendar
                    .date(byAdding: .day, value: count, to: now)
                
                guard let date else {
                    throw ActivityError.daysInitializationFailed
                }
                
                let day = Day(for: date)
                if date <= Date.now {
                    var exceptions: [Int] = []
                    var timestamp: Int = 0
                    
                    for _ in 0..<(1...3).randomElement()! {
                        repeat {
                            timestamp = Int.random(in: 0...2)
                        } while exceptions.contains(timestamp)
                        exceptions.append(timestamp)
                        
                        day.exercises.append(ExerciseModel(
                            exercise: ExerciseManager().exercises[0].exercise,
                            time: Timestamp(rawValue: timestamp) ?? .midday
                        ))
                    }
                    
                    if Calendar.current.component(.weekday, from: date) == 2 {
                        var check = BalanceCheckModel(score: .somewhatStable)
                        check.date = Calendar.current.startOfDay(for: .now)
                        day.check = check
                    }
                }
                
                container.mainContext.insert(day)
            }
        } catch {
            print(error)
        }
        
        return container
    }()
    
    return view()
        .modelContainer(container)
        .preferredColorScheme(.light)
        .environment(Analytics(key: .empty))
}

fileprivate func getNextMonday(after date: Date = Date()) -> Date? {
    let calendar = Calendar.current
    let targetComponents = DateComponents(weekday: 2)
    
    return calendar.nextDate(
        after: date,
        matching: targetComponents,
        matchingPolicy: .nextTime
    )
}
