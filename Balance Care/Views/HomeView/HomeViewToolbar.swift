import SwiftUI

struct HomeViewToolbar: ToolbarContent {
    @Binding var showSources: Bool
    @Binding var showSettings: Bool
    
    var body: some ToolbarContent {
        ToolbarItemGroup(placement: .primaryAction) {
            Button("Sources", systemImage: "books.vertical") {
                showSources.toggle()
            }
            
            Button("Settings", systemImage: "gearshape") {
                showSettings.toggle()
            }
        }
    }
}
