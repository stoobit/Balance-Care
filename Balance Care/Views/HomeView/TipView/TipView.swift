import SwiftUI
import StoreKit

import Analytics

struct TipView: View {
    @Environment(Analytics.self) private var analytics
    @Environment(\.dismiss) private var dismiss
    
    @State private var showThanks: Bool = false
    
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
                .onInAppPurchaseCompletion { product, result in
                    onIAPCompletion(product: product, result: result)
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
            .alert(
                "Thank you for your support!",
                isPresented: $showThanks
            ) {
                Button(role: .close) {
                    showThanks = false
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
    
    private func onIAPCompletion(
        product: Product, result: Result<Product.PurchaseResult, any Error>
    ) {
        Task { @MainActor in
            switch result {
            case .success(let success):
                switch success {
                case .success(let transaction):
                    switch transaction {
                    case .verified(let transaction):
                        showThanks = true
                        analytics.track("Tip", properties: [
                            "type": product.displayName
                        ])
                        
                        await transaction.finish()
                    default:
                        return
                    }
                default:
                    return
                }
            case .failure(_):
                return
            }
        }
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
