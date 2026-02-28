import SwiftUI

struct AboutSheetView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                Section("Balance Scores") {
                    ForEach(BalanceScore.allCases, id: \.rawValue) { score in
                        Label(score.title, systemImage: "\(score.rawValue).circle")
                            .accessibilityLabel(Text("\(score.rawValue) means \(score.title)"))
                            .listRowBackground(
                                Rectangle()
                                    .foregroundStyle(.background)
                            )
                    }
                }
            }
            .navigationTitle("About")
            .scrollIndicators(.hidden)
            .toolbar {
                Button("Close", systemImage: "xmark") {
                    dismiss()
                }
            }
        }
        .presentationDetents([.fraction(0.48)])
        .presentationBackgroundInteraction(.enabled)
    }
}
