import SwiftUI

struct ImprovementsView: View {
    @AppStorage("analytics.share.state")
    private var shareBalanceData: Bool = false
    
    var body: some View {
        Section {
            Toggle("Share Balance Data", systemImage: "chart.bar.fill", isOn: $shareBalanceData)
                .tint(Color.accentColor)
        } header: {
            Text("Improvements")
        } footer: {
            Text("Your balance data is used to improve the accuracy of your balance score.")
        }
    }
}
