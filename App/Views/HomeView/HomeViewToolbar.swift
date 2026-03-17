import SwiftUI

struct HomeViewToolbar: ToolbarContent {
    @Binding var showTip: Bool
    
    @Binding var showSources: Bool
    @Binding var showSettings: Bool
    
    var body: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button("Support Me", systemImage: "heart.fill") {
                showTip.toggle()
            }
            .tint(Color.secondaryAccent)
        }
        
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
