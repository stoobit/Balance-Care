import Foundation

@Observable final class TabManager {
    var current: TabValue = .home
}

enum TabValue: String {
    case home
    case balance
    case exercises
    
    case tip
    
    var title: String {
        return self.rawValue.capitalized
    }
}
