import SwiftUI
import SwiftData

struct BalanceHistoryView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(BalanceManager.self) var balanceManager
    
   var wrappers: [BalanceCheckWrapper]
    
    var body: some View {
        NavigationView {
            List {
                Section("Balance Checks") {
                    ForEach(wrappers) { wrapper in
                       ItemView(for: wrapper.balanceCheck)
                    }
                }
            }
            .navigationTitle("History")
            .toolbar(content: CloseButton)
            .scrollIndicators(.hidden)
        }
    }
    
    @ViewBuilder
    func ItemView(for check: BalanceCheckModel) -> some View {
        let isFirst = check.id == wrappers.first?.balanceCheck.id
        let color = isFirst ? Color.accentColor : Color.secondaryAccentColor
        
        Button(action: { onSelection(of: check) }) {
            HStack(spacing: 15) {
                Image(systemName: "figure.taichi")
                    .foregroundStyle(color)
                    .imageScale(.large)
                
                VStack(alignment: .leading) {
                    Text(check.date.string)
                        .font(.headline)
                        .foregroundStyle(Color.primary)
                    
                    Text(check.score.title)
                        .font(.caption)
                        .foregroundStyle(color)
                }
                
                Spacer()
                
                if balanceManager.selection?.id == check.id {
                    Image(systemName: "checkmark")
                        .foregroundStyle(color)
                        .font(.headline)
                }
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(Text(
            "On \(check.date.string) your balance was \(check.score.title.lowercased())."
        ))
    }
    
    @ToolbarContentBuilder
    func CloseButton() -> some ToolbarContent {
        ToolbarItem(placement: .cancellationAction) {
            Button("Close", systemImage: "xmark") {
                dismiss()
            }
        }
    }
    
    func onSelection(of check: BalanceCheckModel) {
        balanceManager.set(check)
        dismiss()
    }
}
