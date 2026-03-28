import SwiftUI

struct HomeViewToolbar: ToolbarContent {
    @Binding var showTip: Bool
    @Binding var showSources: Bool
    @Binding var showSettings: Bool
    
    var body: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button("Settings", systemImage: "gearshape") {
                showSettings.toggle()
            }
        }
        
        ToolbarItemGroup(placement: .primaryAction) {
            Button("Sources", systemImage: "books.vertical") {
                showSources.toggle()
            }
            
            Button("Support Me", systemImage: "heart") {
                showTip.toggle()
            }
        }
    }
}
