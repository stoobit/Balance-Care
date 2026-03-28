import SwiftUI

struct OnboardingNotificationSettingsView: View {
    @Environment(OnboardingManager.self) var manager
    let configuration = OnboardingNotificationConfiguration()
    
    @State private var animateNotification: Bool = false
    @State private var askPermission: Bool = false
    
    var body: some View {
        ButtonContainer(
            button: "Continue",
            disabled: askPermission,
            action: requestNotificationPermission
        ) {
            VStack {
                ZStack {
                    ViewThatFits(in: .vertical) {
                        VStack(spacing: 20) {
                            iPhonePreview(animateNotification: $animateNotification)
                            TextContent()
                        }
                        .padding(.top)
                        .blurOpacity(!askPermission)
                        
                        ScrollView {
                            TextContent()
                        }
                        .blurOpacity(!askPermission)
                        .scrollIndicators(.hidden)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .navigationTitle("Balance Care")
                .navigationSubtitle("Notifications")
            }
        }
        .navigationBarBackButtonHidden()
    }
    
    @ViewBuilder func TextContent() -> some View {
        VStack(spacing: 15) {
            VStack(alignment: .leading, spacing: 15) {
                Text(configuration.title)
                    .font(.title2.bold())
                    .multilineTextAlignment(.leading)
                    .fixedSize(
                        horizontal: false, vertical: true
                    )
                
                Text(configuration.subtitle)
                    .font(.callout)
                    .foregroundStyle(Color.secondary)
                    .multilineTextAlignment(.leading)
                    .fixedSize(
                        horizontal: false, vertical: true
                    )
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
            .padding(.top, 47)
            
            Spacer()
            
            Button("Skip") {
                manager.showSheet.toggle()
            }
            .fontWeight(.semibold)
            .foregroundStyle(Color.primary)
        }
        .padding(.horizontal, 15)
        .padding(.bottom)
    }
    
    private func requestNotificationPermission() {
        Task { @MainActor in
            await loadAlert()
            await NotificationManager.askPermission()
            
            manager.showSheet = false
        }
    }
    
    private func loadAlert() async {
        withAnimation(.smooth(duration: 0.3, extraBounce: 0)) {
            askPermission = true
        }
    }
}

struct OnboardingNotificationConfiguration {
    let title: String = "Keep Training with Notifications"
    let subtitle: String = "Balance Care will send daily notifications to remind you to practice your balance."
}

#Preview {
    Text("Apple Intelligence")
        .sheet(isPresented: .constant(true)) {
            NavigationStack {
                OnboardingNotificationSettingsView()
                    .environment(OnboardingManager())
            }
        }
}
