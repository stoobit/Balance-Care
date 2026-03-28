import SwiftUI

extension View {
    @ViewBuilder func blurOpacity(_ status: Bool) -> some View {
        self
            .compositingGroup()
            .opacity(status ? 1 : 0)
            .blur(radius: status ? 0 : 10)
    }
}
