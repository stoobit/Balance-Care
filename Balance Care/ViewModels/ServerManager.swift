import Foundation

@Observable final class ServerManager {
    let url = "https://www.stoobit.com"
    
    let key: String = "balance.identifier"
    let id: String
    
    init() {
        if let id = UserDefaults.standard.string(forKey: key) {
            self.id = id
            return
        }
        
        self.id = UUID().uuidString
        UserDefaults.standard.set(self.id, forKey: key)
    }
    
    @discardableResult
    func upload(_ check: BalanceCheckModel) async -> Bool {
        guard let url = URL(string: self.url) else {
            return false
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return true
    }
}


