import Foundation

@Observable final class UploadManager {
    private let url = "https://balancecareapi.stoobit.com/balancedata"
    
    private let key: String = "balance.identifier"
    private let id: String
    
    init() {
        if let id = UserDefaults.standard.string(forKey: key) {
            self.id = id
            return
        }
        
        self.id = UUID().uuidString
        UserDefaults.standard.set(self.id, forKey: key)
    }
    
    func upload(_ check: BalanceCheckModel) async throws {
        guard let url = URL(string: self.url) else {
            throw NetworkingError.urlFailed
        }
        
        var request = URLRequest(url: url)
        request.setValue(KEY, forHTTPHeaderField: "authentication")
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let payload = NetworkingPayload(userID: id, measurements: check.measurements)
        request.httpBody = try JSONEncoder().encode(payload)
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
            throw NetworkingError.invalidStatusCode(statusCode: -1)
        }
        guard (200...299).contains(statusCode) else {
            throw NetworkingError.invalidStatusCode(statusCode: statusCode)
        }
    }
    
    private struct NetworkingPayload: Codable, Identifiable {
        var id = UUID()
        
        var userID: String
        var measurements: [BalanceMeasurement]
    }
    
    private enum NetworkingError: Error {
        case urlFailed
        case invalidStatusCode(statusCode: Int)
    }
}
