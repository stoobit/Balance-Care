import SwiftUI

struct AISummary: View {
    @Environment(AppleIntelligence.self)
    private var appleIntelligence
    
    @AppStorage("AppleIntelligenceSummary")
    var summary: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Label(title: { Text("Summary") }) {
                    Image(systemName: "apple.intelligence")
                        .font(.caption)
                }
                .font(.headline)
                .labelIconToTitleSpacing(10)
                .frame(maxWidth: .infinity, alignment: .leading)
                .accessibilityLabel(Text("Apple Intelligence Summary"))
                
                ProgressView()
                    .opacity(appleIntelligence.isLoading ? 1 : 0)
                    .transition(.blurReplace)
            }
            
            Text(.init(summary))
                .contentTransition(.interpolate)
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity,
                    alignment: .leading
                )
        }
        .padding(.vertical, 3)
        .animation(.smooth, value: summary)
    }
}

#Preview {
    @Previewable var intelligence = AppleIntelligence()
    
    NavigationStack {
        List {
            AISummary()
                .environment(intelligence)
        }
        .task {
            Task { @MainActor in
                intelligence.isLoading = true
            }
            
            try? await Task.sleep(for: .seconds(3))
            
            Task { @MainActor in
                intelligence.isLoading = false
            }
        }
    }
}
