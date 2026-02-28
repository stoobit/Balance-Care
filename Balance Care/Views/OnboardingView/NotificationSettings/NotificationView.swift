import SwiftUI

struct NotificationPreview: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack(spacing: 0) {
            Image("squirrel")
                .resizable()
                .renderingMode(.template)
                .frame(width: 30, height: 30)
                .frame(width: 41, height: 41)
                .foregroundStyle(Color.accentColor.gradient)
                .background(backgroundColor.gradient)
                .clipShape(.rect(cornerRadius: 10))
                .padding(11)
                .compositingGroup()
                .shadow(color: Color.primary.opacity(0.1), radius: 1)
            
            VStack(alignment: .leading) {
                Text(AppName)
                    .foregroundStyle(Color.primary)
                    .font(.footnote.bold())
                
                Text("It’s time for your weekly Balance Check.")
                    .font(.caption2)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 20))
        .frame(height: 63)
        .padding(.horizontal, 12)
        .padding(.top, 50)
    }
    
    var backgroundColor: Color {
        colorScheme == .dark ? Color.black : Color.white
    }
}
