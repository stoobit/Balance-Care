import SwiftUI

struct OnboardingView: View {
    @Environment(OnboardingManager.self) var manager
    @State private var selection: Int? = 0
    
    var body: some View {
        @Bindable var manager = manager
        
        NavigationStack {
            ButtonContainer(button: "Continue", disabled: selection != 2, action: {
                manager.showMicrophoneSettings = true
            }) {
                GeometryReader { proxy in
                    let width = proxy.size.width
                    
                    VStack(spacing: 23) {
                        ScrollView(.horizontal) {
                            LazyHStack(spacing: 5) {
                                ForEach(cards) { card in
                                    AboutCardView(card: card, width: width)
                                        .frame(maxHeight: proxy.size.height * 0.85)
                                        .id(card.id)
                                }
                            }
                            .padding(.horizontal, (width * 0.22) / 2)
                            .scrollTargetLayout()
                        }
                        .scrollTargetBehavior(.viewAligned)
                        .scrollPosition(id: $selection)
                        .scrollIndicators(.hidden)
                        .frame(maxHeight: .infinity)
                        
                        HStack {
                            ForEach(0..<3) { dot in
                                Circle()
                                    .frame(width: 7, height: 7)
                                    .foregroundStyle(
                                        selection == dot ? Color.accentColor : Color.secondary.opacity(0.5)
                                    )
                            }
                        }
                        .animation(.smooth, value: selection)
                        .padding(.bottom, 20)
                    }
                }
                .frame(maxHeight: .infinity, alignment: .bottom)
                .navigationTitle(AppName)
                .navigationSubtitle("About")
            }
            .navigationDestination(isPresented: $manager.showMicrophoneSettings) {
                OnboardingMicrophoneSettingsView()
            }
        }
        .interactiveDismissDisabled()
    }
}
