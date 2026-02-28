import Foundation

@Observable final class TabManager {
    var current: TabValue = .home
}

enum TabValue: String {
    case home
    case balance
    case exercises
    
    var title: String {
        return self.rawValue.capitalized
    }
}
