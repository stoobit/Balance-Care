import SwiftUI
import SwiftData

import Analytics

struct ImprovementsView: View {
    @Query var wrappers: [BalanceCheckWrapper]
    
    @Environment(UploadManager.self) private var upload
    @Environment(Analytics.self) private var analyticy
    
    @AppStorage("analytics.share.state")
    private var shareBalanceData: Bool = false
    
    var body: some View {
        Section {
            Toggle("Share Balance Data", systemImage: "chart.dots.scatter", isOn: $shareBalanceData)
                .tint(Color.accentColor)
        } header: {
            Text("Improvements")
        } footer: {
            Text("Your balance data is used to improve the accuracy of your balance score.")
        }
        .onChange(of: shareBalanceData, share)
    }
    
    func share() {
        // Record Opt-In
        analyticy.track("Balance Data", properties: [
            "action": shareBalanceData ? "opt-in" : "opt-out"
        ])
        
        // Data Upload
        if shareBalanceData {
            Task {
                let wrappers = self.wrappers
                    .filter({ $0.state == .none })
                
                for wrapper in wrappers {
                    do {
                        try await upload.upload(wrapper.balanceCheck)
                        wrapper.state = .uploaded
                    } catch {
                        wrapper.state = .none
                        print(error)
                    }
                }
            }
        }
    }
}
