import SwiftUI

struct OrientationWrapper<Content: View>: View {
    @ViewBuilder var content: Content
    
    var body: some View {
        GeometryReader { proxy in
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .overlay {
                    if proxy.size.width > proxy.size.height {
                        ZStack {
                            Rectangle()
                                .foregroundStyle(.thinMaterial)
                                .ignoresSafeArea(.all)
                            
                            ContentUnavailableView(
                                "Landscape Mode Not Supported",
                                systemImage: "iphone.landscape"
                            )
                        }
                    }
                }
        }
    }
}
