import SwiftUI

struct iPhonePreview: View {
    @Binding var animateNotification: Bool
    
    var body: some View {
        GeometryReader {
            let scale = min($0.size.width / 340, 1)
            
            let width: CGFloat = 320
            let cornerRadius: CGFloat = 45
            
            ZStack(alignment: .top) {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color.primary.opacity(0.06))
                
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(.gray.opacity(0.5), lineWidth: 1.5)
                
                VStack(spacing: 15) {
                    HStack(spacing: 15) {
                        let columns = Array(
                            repeating: GridItem(spacing: 15), count: 2
                        )
                        
                        LazyVGrid(columns: columns, spacing: 15) {
                            ForEach(1...4, id: \.self) { _ in
                                RoundedRectangle(cornerRadius: 13)
                                    .frame(width: 55, height: 55)
                            }
                        }
                        
                        RoundedRectangle(cornerRadius: 20)
                    }
                    .frame(height: 130)
                    
                    let columns = Array(
                        repeating: GridItem(spacing: 15), count: 4
                    )
                    
                    LazyVGrid(columns: columns, spacing: 15) {
                        ForEach(1...8, id: \.self) { _ in
                            RoundedRectangle(cornerRadius: 13)
                                .frame(width: 55, height: 55)
                        }
                    }
                }
                .padding(30)
                .padding(.top, 30)
                .foregroundStyle(Color.primary.opacity(0.1))
                
                HStack(spacing: 4) {
                    Text("9:41")
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Image(systemName: "cellularbars")
                    Image(systemName: "wifi")
                    Image(systemName: "battery.75percent")
                        .foregroundStyle(Color.primary, Color.secondary)
                }
                .font(.footnote)
                .padding(.horizontal, 30)
                .padding(.top, 26)
                
                NotificationPreview()
                    .offset(y: animateNotification ? 0 : -200)
                    .task { await showAnimation() }
            }
            .frame(width: width)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: .top
            )
            .mask {
                LinearGradient(
                    stops: [
                        .init(color: .white, location: 0.4),
                        .init(color: .clear, location: 0.9)
                    ], startPoint: .top, endPoint: .bottom
                )
                .padding(-1)
            }
            .scaleEffect(scale, anchor: .top)
            .dynamicTypeSize(.large)
        }
    }
    
    private func showAnimation() async {
        try? await Task.sleep(for: .seconds(0.5))
        
        withAnimation(.smooth(duration: 0.6)) {
            animateNotification = true
        }
    }
}
