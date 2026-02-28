import SwiftUI

struct DefaultViewStyle: ViewModifier {
    @Environment(\.colorScheme) var colorScheme

    func body(content: Content) -> some View {
        content
            .scrollIndicators(.hidden)
            .background {
                UniversalBackgroundColor()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea()
            }
    }
}

struct UniversalBackgroundColor: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        colorScheme == .dark ? Color.black : Color(.secondarySystemBackground)
    }
}

extension View {
    @ViewBuilder
    func defaultViewStyle() -> some View {
        modifier(DefaultViewStyle())
    }
}
