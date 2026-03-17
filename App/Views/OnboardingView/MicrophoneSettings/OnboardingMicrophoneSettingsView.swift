import SwiftUI
import Speech
import AVFoundation

struct OnboardingMicrophoneSettingsView: View {
    @Environment(OnboardingManager.self) var manager
    let configuration = OnboardingMicrophoneConfiguration()
    
    @State private var askPermission: Bool = false
    @State private var start = Date.now
    
    var body: some View {
        @Bindable var manager = manager
        
        ButtonContainer(
            button: "Continue", disabled: askPermission,
            action: requestMicrophonePermission
        ) {
            ViewThatFits(in: .vertical) {
                ViewContent()
                
                ScrollView {
                    ViewContent()
                }
                .scrollIndicators(.hidden)
            }
        }
        .navigationBarBackButtonHidden()
        .navigationDestination(isPresented: $manager.showNotificationSettings) {
            OnboardingNotificationSettingsView()
        }
    }
    
    @ViewBuilder func ViewContent() -> some View {
        ZStack {
            VStack(spacing: 20) {
                Image(systemName: "waveform.badge.microphone")
                    .foregroundStyle(Color.primary, Color.secondaryAccentColor)
                    .font(.system(size: 160))
                    .symbolEffect(
                        .variableColor.cumulative.dimInactiveLayers.nonReversing,
                        options: .repeat(.continuous)
                    )
                    .frame(maxHeight: .infinity)
                
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
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 20)
                    
                    Spacer()
                }
                .padding(.horizontal, 15)
                .padding(.bottom)
            }
            .padding(.top)
            .blurOpacity(!askPermission)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle("Balance Care")
        .navigationSubtitle("Balance Check")
    }
    
    private func requestMicrophonePermission() {
        Task { @MainActor in
            await loadAlert()
            
            _ = await AVAudioApplication.requestRecordPermission()
            _ = await SFSpeechRecognizer.hasAuthorizationToRecognize()
            
            manager.showNotificationSettings = true
        }
    }
    
    private func loadAlert() async {
        withAnimation(.smooth(duration: 0.3, extraBounce: 0)) {
            askPermission = true
        }
    }
}

struct OnboardingMicrophoneConfiguration {
    let title: String = "Prepare Your Balance Check"
    let subtitle: String = "To prepare your Balance Check, Balance Care needs access to your microphone and speech recognition. This step won't start a Balance Check yet. It simply makes sure everything is ready when you begin."
}

#Preview {
    Text("Apple Intelligence")
        .sheet(isPresented: .constant(true)) {
            NavigationStack {
                OnboardingMicrophoneSettingsView()
                    .environment(OnboardingManager())
            }
        }
}
