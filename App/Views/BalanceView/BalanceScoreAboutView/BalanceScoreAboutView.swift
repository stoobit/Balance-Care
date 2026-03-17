import SwiftUI
import Charts

struct BalanceScoreAboutView: View {
    @Environment(\.colorSchemeContrast) var contrast
    @Environment(\.colorScheme) var colorScheme
    
    @Environment(BalanceManager.self) var manager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            BalanceScoreAboutToolbar()
            
            let size: CGFloat = 100
            VStack {
                VStack {
                    AppClipIcon(size: size)
                    Text("Balance Lab")
                        .font(.headline)
                }
                .offset(y: -50/3)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("About")
                        .font(.headline)
                        .foregroundStyle(Color.secondary)
                        .padding(.horizontal, 15)
                    
                    Text(about)
                        .lineSpacing(10)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                        .scenePadding()
                        .background(.background.secondary)
                        .clipShape(.rect(cornerRadius: 17))
                }
                .scenePadding([.horizontal, .bottom])
                .padding(.top, 5)
            }
            .frame(maxWidth: .infinity)
        }
        .frame(
            maxWidth: .infinity,
            alignment: .bottom
        )
        .blurOpacity(manager.isAbout)
    }
    
    @ViewBuilder
    func AppClipIcon(size: CGFloat) -> some View {
        ZStack {
            Image(systemName: "appclip")
                .foregroundStyle(Color.accentColor.gradient)
                .font(.system(size: size))
            
            Image(systemName: "gyroscope")
                .resizable()
                .foregroundStyle(color.gradient)
                .frame(width: size / 2.5, height: size / 2.5)
                .scaledToFit()
        }
    }
    
    private var color: Color {
        if colorScheme == .light && contrast == .increased {
            return Color.white
        }
        
        return Color.black
    }
    
    private let about: String = """
        The Balance Score is determined by a custom machine learning model trained on data collected with the Balance Lab app, available as an App Clip on the App Store.
        """
}
