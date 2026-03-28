import SwiftUI

struct ButtonContainer<Content: View>: View {
    @Environment(\.colorSchemeContrast) var contrast
    @Environment(\.colorScheme) var colorScheme
    
    var button: String
    var disabled: Bool
    
    var action: () -> Void
    @ViewBuilder var content: Content
    
    var body: some View {
        GeometryReader { proxy in
            content
                .toolbar {
                    let width = proxy.size.width - 60
                    
                    ToolbarItem(placement: .bottomBar) {
                        Button(action: action) {
                            Text(button)
                                .font(.headline)
                                .foregroundStyle(text)
                                .frame(width: max(0, width), height: 40)
                        }
                        .buttonStyle(.glassProminent)
                        .foregroundStyle(tint)
                        .disabled(disabled)
                        .scenePadding(.horizontal)
                        .frame(width: max(0, width), height: 40)
                    }
                }
        }
    }
    
    var tint: Color {
        disabled ? Color.secondary : Color.accentColor
    }
    
    var text: Color {
        if disabled {
            return Color.primary
        }
        
        if contrast == .increased {
            return colorScheme == .dark ? Color.black : Color.white
        }
        
        return Color.black
    }
}
