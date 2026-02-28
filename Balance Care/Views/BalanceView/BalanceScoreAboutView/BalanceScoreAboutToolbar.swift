import SwiftUI

struct BalanceScoreAboutToolbar: View {
    @Environment(BalanceManager.self) private var manager
    @Environment(\.openURL) private var openURL
    
    var body: some View {
        HStack(alignment: .center) {
            Button("Close", image: "xmark") {
                manager.isAbout = false
            }
            
            Spacer()
            
            Button("App Clip", image: "arrow.up.forward.app") {
                openAppClip()
            }
        }
    }
    
    func openAppClip() {
        let domain = "https://appclip.apple.com"
        let path = "/id?p=com.stoobit.lab.Clip"
        
        if let url = URL(string: "\(domain)\(path)") {
            openURL(url)
        }
    }
}


fileprivate struct Button: View {
    init(_ title: String, image: String, action: @escaping () -> Void) {
        self.title = title
        self.image = image
        self.action = action
    }
    
    var title: String
    var image: String
    var action: () -> Void
    
    var body: some View {
        SwiftUI.Button(action: action) {
            Label(title, systemImage: image)
                .labelStyle(.iconOnly)
                .imageScale(.large)
                .foregroundStyle(Color.primary)
                .padding(10)
                .background {
                    Circle()
                        .foregroundStyle(.ultraThinMaterial)
                }
        }
        .padding(10)
    }
}
