import SwiftUI
import SwiftData

import Analytics

struct ContentView: View {
    @AppStorage("InitialDate")
    var initialDate: Date = .initial
    
    @Query(sort: [SortDescriptor(\Day.date)], animation: .default)
    var days: [Day]
    
    @Query(sort: [
        SortDescriptor(\BalanceCheckWrapper.balanceCheck.date, order: .reverse)
    ]) var balanceChecks: [BalanceCheckWrapper]
    
    @Environment(Analytics.self) var analytics
    
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.modelContext) private var context
    
    @State var appleIntelligence = AppleIntelligence()
    @State var onboarding = OnboardingManager()
    @State var exercises = ExerciseManager()
    @State var activity = ActivityManager()
    @State var balance = BalanceManager()
    @State var tab = TabManager()
    
    private var selection: TabValue? = nil
    private var initializeDays: Bool? = true
    init(selection: TabValue? = nil, initializeDays: Bool? = true) {
        self.selection = selection
        self.initializeDays = initializeDays
    }
    
    var body: some View {
        TabView(selection: $tab.current) {
            Tab("Overview", systemImage: "house", value: TabValue.home) {
                HomeView(days: days, balanceChecks: balanceChecks)
            }
            
            if balanceChecks.isEmpty == false {
                Tab("Balance", systemImage: "figure.taichi", value: TabValue.balance) {
                    BalanceView()
                }
            }
            
            Tab("Exercises", systemImage: "figure.cross.training", value: TabValue.exercises) {
                ExerciseView()
            }
        }
        .toolbarVisibility(.hidden, for: .tabBar)
        .sheet(isPresented: $onboarding.showSheet, onDismiss: onboarding.complete) {
            OnboardingView()
        }
        .environment(appleIntelligence)
        .environment(onboarding)
        .environment(exercises)
        .environment(activity)
        .environment(balance)
        .environment(tab)
        .onAppear(perform: debug)
        .onAppear(perform: initialize)
        .onChange(of: scenePhase, load)
        .onChange(of: tab.current, analyticsTabChange)
        .onChange(of: balanceChecks.count, setNotifications)
        .task { await exercises.images(context: context) }
    }
    
    private func initialize() {
        // Initial Date
        if initialDate == .initial {
            initialDate = Calendar
                .current.startOfDay(for: Date())
        }
        
        // Balance Check
        if let lastCheck = balanceChecks.first?.balanceCheck {
            balance.set(lastCheck)
        }
        
        // Days
#if DEBUG
        if let initializeDays, initializeDays {
            let result = activity.initialize(with: context)
            onboarding.showErrorAlert = result
        }
#else
        let result = activity.initialize(with: context)
        onboarding.showErrorAlert = result
#endif
        
        load()
    }
    
    private func load() {
        // Notifications
        NotificationManager.removeDeliveredNotifications()
        
        // Apple Intelligence
        appleIntelligence.setup()
        
        // Activity
        /// Current Day/Week
        activity.loadCurrentWeek(from: days)
        activity.loadCurrentDay(using: days)
        
        /// Recent Months
        activity.loadBalanceProgressRange(from: days)
        activity.loadExerciseFrequencyRange(from: days)
        
        /// Average Rating
        activity.loadAverageBalanceRatings(from: balanceChecks)
    }
    
    // MARK: - Notifications
    private func setNotifications() {
        if balanceChecks.count == 1 {
            NotificationManager
                .setNotifications(morning, midday, afternoon)
        }
    }
    
    @AppStorage("MorningDate")
    var morning: Date = .time(hour: 9)
    
    @AppStorage("MiddayDate")
    var midday: Date = .time(hour: 11)
    
    @AppStorage("AfternoonDate")
    var afternoon: Date = .time(hour: 15)
    
    // MARK: - Analytics
    private func analyticsTabChange() {
        analytics.track("Tab Changed", properties: ["tab": tab.current.title])
    }
    
    // MARK: - Debug
    private func debug() {
#if DEBUG
        if let selection {
            tab.current = selection
        }
        
//        NotificationManager.pendingNotifications()
#endif
    }
}

#Preview("Main Preview") {
    ContentView()
        .modelContainer(for: Day.self, inMemory: true)
}
