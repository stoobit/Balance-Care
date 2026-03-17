import Foundation
import FoundationModels

@MainActor
@Observable final class AppleIntelligence {
    private var session: LanguageModelSession?
    
    var isAvailable: Bool = false
    var isLoading: Bool = false
    
    func setup() {
        isAvailable = self.checkAvailability()
        session = LanguageModelSession(instructions: instructions)
    }
    
    func respond(to prompt: Prompt) async -> String {
        do {
            guard let session else {
                throw AppleIntelligenceError.sessionInvalid
            }
            
            self.isLoading = true
            let response = try await session.respond(to: prompt)
            
            self.isLoading = false
            return response.content
            
        } catch {
            self.isLoading = false
            return .empty
        }
    }
    
    private func checkAvailability() -> Bool {
        let model = SystemLanguageModel.default
        
        switch model.availability {
        case .available:
            return true
        default:
            return false
        }
    }
    
    private enum AppleIntelligenceError: Error {
        case sessionInvalid
    }
}

