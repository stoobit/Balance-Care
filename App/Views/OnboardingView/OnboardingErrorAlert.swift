import SwiftUI

struct OnboardingErrorAlert: ViewModifier {
    @Binding var showAlert: Bool
    
    let title: LocalizedStringKey = "Something Went Wrong"
    let message: LocalizedStringKey = "Please restart the app to fix this error. If the problem persists, reinstall the app."
    
    func body(content: Content) -> some View {
        content
            .alert(title, isPresented: $showAlert) {
                Button("Close App", role: .cancel, action: close)
            } message: {
                Text(message)
            }
    }
    
    func close() {
        UIControl().sendAction(
            #selector(URLSessionTask.suspend),
            to: UIApplication.shared, for: nil
        )
        
        Timer.scheduledTimer(
            withTimeInterval: 0.2, repeats: false
        ) { timer in exit(0) }
    }
}

extension View {
    @ViewBuilder
    func onboardingErrorAlert(isPresented: Binding<Bool>) -> some View {
        modifier(OnboardingErrorAlert(showAlert: isPresented))
    }
}
