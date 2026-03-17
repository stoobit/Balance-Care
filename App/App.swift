import TipKit
import SwiftUI
import SwiftData

import Analytics

// IMPORTANT:
// Opening the app using Mac Catalyst will open the ML tool.

@main
struct Application: App {
    @Environment(\.scenePhase) private var scenePhase
    @State private var analytics = Analytics(key: KEY)
    
    var body: some Scene {
        WindowGroup {
#if targetEnvironment(macCatalyst)
            MachineLearningView()
#else
            OrientationWrapper {
                ContentView()
                    .environment(analytics)
                    .onChange(
                        of: scenePhase,
                        analyticsScenePhaseChange
                    )
            }
            .modelContainer(for: [
                Day.self,
                ImageModel.self,
                BalanceCheckWrapper.self
            ], isAutosaveEnabled: true)
#endif
        }
        .windowResizability(.contentSize)
    }
    
    func analyticsScenePhaseChange() {
        if scenePhase == .active {
            analytics.track("App Opened")
        }
        
        analytics.flush()
    }
}

extension Color {
   static var secondaryAccentColor: Color {
        return Color("SecondaryAccentColor")
    }
}
