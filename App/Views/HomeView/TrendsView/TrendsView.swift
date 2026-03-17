import SwiftUI

struct TrendsView: View {
    @Environment(AppleIntelligence.self) var appleIntelligence
    
    @AppStorage("AppleIntelligenceSummary")
    var summary: String = ""
    
    var body: some View {
        if showAppleIntelligenceSummary {
            Section {
                AISummary()
            } header: {
                Text("Trends")
            } footer: {
                Text("AI-generated summaries can be inaccurate.")
            }

            
            Section {
                ImprovementChart()
            }
            .listSectionSpacing(20)
        } else {
            Section("Trends") {
                ImprovementChart()
            }
        }
        
        Section {
            ExerciseChart()
        }
        .listSectionSpacing(20)
    }
    
    var showAppleIntelligenceSummary: Bool {
        return appleIntelligence.isAvailable && !summary.isEmpty
    }
}
