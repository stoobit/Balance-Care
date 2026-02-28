import TipKit
import SwiftUI
import SwiftData

import Analytics

// IMPORTANT:
// Opening the app using Mac Catalyst will open the ML tool.

@main
struct Application: App {
    @Environment(\.scenePhase) private var scenePhase
    @State private var analytics = Analytics(
        key: "5ef538394df9d9c666812d2c237f35c6"
    )
    
    var body: some Scene {
        WindowGroup {
#if targetEnvironment(macCatalyst)
            MachineLearningView()
#else
            OrientationWrapper {
                ContentView()
                    .environment(analytics)
                    .onChange(of: scenePhase, analyticsScenePhaseChange)
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

let AppName: String = "Balance Care"
extension Color {
   static var secondaryAccentColor: Color {
        return Color("SecondaryAccentColor")
    }
}
