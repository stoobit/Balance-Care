import SwiftUI

struct BalanceViewToolbar: ToolbarContent {
    @Environment(BalanceManager.self) var manager
    var wrappers: [BalanceCheckWrapper]
    
    @State var showCheck: Bool = false
    @State var showHistory: Bool = false
    
    var body: some ToolbarContent {
        ToolbarItemGroup(placement: .primaryAction) {
            Button("History", systemImage: "clock") {
                showHistory.toggle()
                reset()
            }
            .sheet(isPresented: $showHistory) {
                BalanceHistoryView(wrappers: wrappers)
            }
            
            Button("Balance Check", systemImage: "plus") {
                showCheck.toggle()
                reset()
            }
            .fullScreenCover(isPresented: $showCheck) {
                BalanceCheckContainer(isPresented: $showCheck, context: .custom)
            }
        }
    }
    
    private func reset() {
        Task { @MainActor in
            try await Task.sleep(for: .seconds(0.5))
            manager.reset()
        }
    }
}
