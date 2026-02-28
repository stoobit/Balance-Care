import SwiftUI
import SwiftData

extension BalanceCheckView {
    func scoreCheck() {
        Task {
            do {
                guard let day = activity.currentDay else {
                    return
                }
                
                // Machine Learning Prediciton
                #if targetEnvironment(simulator)
                let score = BalanceScore.allCases.randomElement() ?? .none
                #else
                let prediction = try await MachineLearningModel.prediction(
                    using: motion.balanceCheck.measurements
                )
                
                let score = try BalanceScore(from: prediction)
                #endif
                
                motion.balanceCheck.score = score
                motion.balanceCheck.progress = wrappers.progress(for: score)
                
                // Save Check to SwiftData
                let wrapper = BalanceCheckWrapper(for: motion.balanceCheck)
                modelContext.insert(wrapper)
                
                // Save Check to Current Day
                if context == .weekly {
                    day.check = motion.balanceCheck
                }
                
                // Select Check in Balance Tab
                balance.set(motion.balanceCheck)
            } catch {
                print("ML:", error)
            }
        }
    }
    
    func speak() {
        let value: Double = Double(motion.balanceCheck.measurements.count)
        let max: Double = 20 / interval
        
        switch value {
        case max * 0.50: try? audio.speak(.half)
        case max * 1.00:
            state = .finished
            try? audio.speak(.finished)
        default:
            return
        }
    }
    
    func startTranscription() {
        transcription.resetTranscript()
        transcription.startTranscribing {
            self.transcription.stopTranscribing()
            
            Task { @MainActor in
                try await Task.sleep(for: .seconds(0.1))
                self.state = .running
            }
        }
        
    }
    
    func stateChange() {
        if state == .running {
            try? audio.speak(.start)
            motion.startMeasuring(with: interval)
            return
        } else {
            motion.stopMeasuring()
        }
        
        if state == .finished {
            scoreCheck()
            return
        }
        
        if state == .ready {
            startTranscription()
            return
        }
    }
    
    func triggerFeedback(
        old: BalanceCheckViewState, new: BalanceCheckViewState
    ) -> Bool {
        let isRunning: Bool = old == .ready && new == .running
        let isFinished: Bool = old == .running && new == .finished
        
        return isRunning || isFinished
    }
    
    func setIdleTimer(disabled: Bool) {
        UIApplication.shared.isIdleTimerDisabled = disabled
    }
    
    func onSlide() {
        audio.stop()
        
        switch state {
        case .ready: dismiss()
        case .running:
            withAnimation {
                state = .ready
            }
        case .finished:
            tab.current = .balance
            isPresented = false
        }
    }
    
    func presentAlert() {
        let currentScore = wrappers.first?.balanceCheck.score ?? .none
        let scores: [BalanceScore] = [.unstable, .somewhatStable, .none]
        
        if scores.contains(currentScore) {
            Task { @MainActor in
                try? await Task.sleep(for: .seconds(0.5))
                showAlert.toggle()
            }
        }
    }
    
    // MARK: - DEBU
    func DEBUGTAP() {
#if DEBUG
        switch state {
        case .ready:
            state = .running
        case .running:
            state = .finished
        default:
            return
        }
#endif
    }
}
