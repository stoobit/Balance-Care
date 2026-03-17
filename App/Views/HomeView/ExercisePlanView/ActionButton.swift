import SwiftUI

struct ActionButton: View {
    @Environment(\.colorSchemeContrast) var contrast
    @Environment(\.colorScheme) var colorScheme
    
    var type: ActionType
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Label(type.title, systemImage: type.image)
                .foregroundStyle(exerciseColor)
                .font(.headline)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(type.color)
        }
        .buttonStyle(.plain)
        .listRowInsets(EdgeInsets())
        .listRowBackground(Color.clear)
    }
    
    var exerciseColor: Color {
        if contrast == .increased {
            return colorScheme == .dark ? Color.black : Color.white
        }
        
        if type == .balanceCheck {
            return Color.white
        }
        
        return Color.black
    }
}
