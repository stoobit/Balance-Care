import SwiftUI

struct BalanceToastView: View {
    @Environment(\.dynamicTypeSize) var typeSize
    @Environment(\.colorScheme) var colorScheme
    
    @AppStorage("Balance Toast")
    var isPresented: Bool = true
    
    var body: some View {
        VStack {
            if isPresented {
                switch colorScheme {
                case .dark:
                    ToastView(color: .background.secondary)
                case .light:
                    ToastView(color: .background)
                default:
                    EmptyView()
                }
            }
        }
        .transition(.blurReplace)
        .animation(.bouncy, value: isPresented)
    }
    
    private func accessibilitySize() -> DynamicTypeSize {
        if [.xSmall, .small, .medium, .large].contains(typeSize) {
            return typeSize
        }
        
        return .xLarge
    }
    
    @ViewBuilder func ToastView(color: some ShapeStyle) -> some View {
        HStack(spacing: 8) {
            Text("The green circle mirrors your movement.")
                .font(.footnote)
                .padding(10)
                .background(color)
                .clipShape(.capsule)
            
            Button(action: {
                isPresented = false
            }) {
                Image(systemName: "xmark")
                    .foregroundStyle(Color.primary)
                    .font(.footnote)
                    .padding(10)
                    .background(color)
                    .clipShape(.circle)
            }
        }
        .dynamicTypeSize(accessibilitySize())
        .scenePadding(.horizontal)
    }
}
