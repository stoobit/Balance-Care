import SwiftUI
import SwiftData
import FoundationModels

struct HomeView: View {
    @Environment(AppleIntelligence.self) var intelligence
    @Environment(ActivityManager.self) var activity
    @Environment(BalanceManager.self) var balance
    
    @AppStorage("AppleIntelligenceSummary")
    var summary: String = ""
    
    @AppStorage("InitialDate")
    var initialDate: Date = .initial
    
    @State private var showTip: Bool = false
    @State private var showSources: Bool = false
    @State private var showSettings: Bool = false
    
    var days: [Day]
    var balanceChecks: [BalanceCheckWrapper]
    
    var body: some View {
        NavigationStack {
            List {
                if let check = balanceChecks.first?.balanceCheck {
                    BalanceScoreOverview(check: check)
                }
                
                ExercisePlanView(balanceChecks: balanceChecks)
                
                TrendsView()
                    .onChange(of: balanceChecks.count, balanceChecksDidChange)
                    .onChange(of: exercises, generateSummary)
            }
            .animation(.default, value: score)
            .defaultViewStyle()
            .navigationTitle("Overview")
            .sheet(isPresented: $showTip) {
                TipView()
            }
            .sheet(isPresented: $showSources) {
                SourcesView()
            }
            .sheet(isPresented: $showSettings) {
                SettingsView(balanceChecks: balanceChecks)
            }
            .toolbar {
                HomeViewToolbar(
                    showTip: $showTip,
                    showSources: $showSources,
                    showSettings: $showSettings,
                )
            }
        }
    }
    
    private var exercises: Int? {
        activity.currentDay?.exercises.count
    }
    
    private var score: BalanceScore? {
        return balanceChecks.first?.balanceCheck.score
    }
    
    private func balanceChecksDidChange() {
        activity.loadAverageBalanceRatings(from: balanceChecks)
        generateSummary()
    }
    
    private func generateSummary() {
        Task { @MainActor in
            let response = await intelligence.response(
                for: initialDate, activity: activity,
                check: balanceChecks.first?.balanceCheck
            )
            
            withAnimation(.default) {
                self.summary = response
            }
        }
    }
}
