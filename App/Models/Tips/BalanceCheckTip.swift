import TipKit
import SwiftUI

struct BalanceCheckTip: Tip {
    var title: Text {
        Text("Get Started")
            .foregroundStyle(Color.accentColor)
    }
    
    var message: Text? {
        Text("Take your first Balance Check to see how your balance is doing.")
            .foregroundStyle(Color.primary)
    }
    
    var options: [Option] {
        MaxDisplayCount(1)
    }
}
