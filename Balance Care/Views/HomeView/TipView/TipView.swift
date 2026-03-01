import SwiftUI
import StoreKit

struct TipView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                Section("Tips") {
                    ProductView(id: "com.stoobit.BalanceCare.SmallTip") {
                        HeartView(opacity: 0.6)
                    }
                    
                    ProductView(id: "com.stoobit.BalanceCare.MediumTip") {
                        HeartView(opacity: 0.8)
                    }
                    
                    ProductView(id: "com.stoobit.BalanceCare.LargeTip") {
                        HeartView(opacity: 1.0)
                    }
                }
            }
            .productViewStyle(.compact)
            .productDescription(.hidden)
            .navigationTitle("Support Me")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close", systemImage: "xmark") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    @ViewBuilder func HeartView(opacity: CGFloat) -> some View {
        Image(systemName: "heart.fill")
            .imageScale(.large)
            .foregroundStyle(
                Color
                    .secondaryAccent
                    .opacity(opacity)
            )
    }
}

#Preview {
    @Previewable
    @State var isPresented: Bool = true
    
    Button("Toggle Sheet") {
        isPresented.toggle()
    }
    .sheet(isPresented: $isPresented) {
        TipView()
    }
}
