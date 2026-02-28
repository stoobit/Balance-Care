import SwiftUI

struct BalanceCheckContainer: View {
    @Binding var isPresented: Bool
    var context: BalanceCheckView.Context
    
    var body: some View {
        NavigationStack {
            CheckInstructionView(isPresented: $isPresented, context: context)
                .navigationTitle("Balance Check")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel", systemImage: "xmark") {
                            isPresented.toggle()
                        }
                    }
                }
        }
    }
}
