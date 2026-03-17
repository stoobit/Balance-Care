import SwiftUI

struct BalanceBoardView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                Section("") {
                    Image("balanceboard")
                        .resizable()
                        .scaledToFill()
                        .listRowInsets(EdgeInsets())
                }
                
                Section("About") {
                   Text("Balance boards are the perfect companion to the exercises in Balance Care. While the exercises in this app help building a solid foundation, adding a board introduces dynamic movement that activates deep muscles and improves your coordination. This extra challenge not only strengthens your body but also boosts mental fitness by requiring focus."
                   )
                   .lineSpacing(10)
                }
            }
            .navigationTitle("Balance Boards")
            .scrollIndicators(.hidden)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close", systemImage: "xmark") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    BalanceBoardView()
}
