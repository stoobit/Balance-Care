import Foundation

#if DEBUG
import Playgrounds
#endif

@Observable final class NetworkingManager {
    #if DEBUG
    private let url = "http://127.0.0.1:8080"
    #else
    private let url = "https://"
    #endif
    
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
        request.setValue("authentication", forHTTPHeaderField: KEY)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let payload = NetworkingPayload(id: id, measurements: check.measurements)
        request.httpBody = try JSONEncoder().encode(payload)
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
            throw NetworkingError.invalidStatusCode(statusCode: -1)
        }
        guard (200...299).contains(statusCode) else {
            throw NetworkingError.invalidStatusCode(statusCode: statusCode)
        }
    }
    
    private struct NetworkingPayload: Codable {
        var id: String
        var measurements: [BalanceMeasurement]
    }
    
    private enum NetworkingError: Error {
        case urlFailed
        case invalidStatusCode(statusCode: Int)
    }
}
