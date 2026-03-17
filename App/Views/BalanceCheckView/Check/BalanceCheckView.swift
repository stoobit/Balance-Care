import SwiftUI

import Analytics

struct BalanceCheckView: View {
    @Binding var isPresented: Bool
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @Environment(Analytics.self) var analytics
    
    @Environment(TabManager.self) var tab
    @Environment(BalanceManager.self) var balance
    @Environment(ActivityManager.self) var activity
    
    @State var showAlert: Bool = false
    @State var state: BalanceCheckViewState = .ready
    
    @State var transcription = TranscriptionManager()
    @State var motion = MotionManager()
    @State var audio = AudioManager()
    
    var context: Self.Context
    var wrappers: [BalanceCheckWrapper]
    
    let interval: Double = 1/100
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            ViewThatFits(in: .vertical) {
                VStack(spacing: 20) {
                    Image(systemName: state.image)
                        .foregroundStyle(state.primaryColor, state.secondaryColor)
                        .font(.system(size: 120))
                        .symbolEffect(
                            .variableColor.cumulative.dimInactiveLayers.nonReversing,
                            options: .repeat(.continuous), isActive: state != .finished
                        )
                        .frame(height: 140)
                        .contentTransition(.symbolEffect)
                    
                    Text(state.description)
                        .multilineTextAlignment(.leading)
                        .scenePadding()
                    
//                    #if DEBUG
//                    if state != .finished {
//                        Button("Simulator: Tap to Continue") {
//                            DEBUGTAP()
//                        }
//                    }
//                    #endif
                }
                
                Text(state.description)
                    .multilineTextAlignment(.leading)
                    .scenePadding()
            }
            
            Spacer()
            
            SliderView(
                title: state.swipeAction,
                image: state.slider, action: onSlide
            )
            .contentTransition(.identity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationBarBackButtonHidden()
        .navigationTitle("Balance Check")
        .onChange(of: motion.balanceCheck.measurements.count, speak)
        .onChange(of: state, initial: true, stateChange)
        .onDisappear {
            setIdleTimer(disabled: false)
            transcription.stopTranscribing()
        }
        .onAppear {
//            presentAlert()
            setIdleTimer(disabled: true)
        }
        .sensoryFeedback(.error, trigger: state) { old, new in
            return triggerFeedback(old: old, new: new)
        }
        .interactiveDismissDisabled()
        .alert("Safety First", isPresented: $showAlert) {
            Button("Continue", role: .cancel) {
                showAlert = false
            }
        } message: {
            Text("Please ensure you are within reach of a sturdy support, like a wall or chair, before starting this exercise.")
        }
        .defersSystemGestures(on: .all)
    }
    
    enum Context {
        case weekly, custom
    }
}
