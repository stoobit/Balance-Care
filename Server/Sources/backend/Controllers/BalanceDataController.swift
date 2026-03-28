import Fluent
import Vapor

struct BalanceDataController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let todos = routes.grouped("balancedata")

        todos.get(use: self.index)
        todos.post(use: self.create)
        todos.group(":userID") { todo in
            todo.delete(use: self.delete)
        }
    }

    @Sendable
    func index(req: Request) async throws -> [BalanceDataDTO] {
        try await BalanceData.query(on: req.db).all().map { $0.toDTO() }
    }

    @Sendable
    func create(req: Request) async throws -> BalanceDataDTO {
        guard req.headers["authentication"].first == KEY else {
            throw Abort(.forbidden)
        }
        
        let todo = try req.content.decode(BalanceDataDTO.self).toModel()

        try await todo.save(on: req.db)
        return todo.toDTO()
    }

    @Sendable
    func delete(req: Request) async throws -> HTTPStatus {
        guard req.headers["authentication"].first == KEY else {
            throw Abort(.forbidden)
        }
        
        guard let userID: String = req.parameters.get("userID") else {
            throw Abort(.badRequest)
        }
        
        try await BalanceData.query(on: req.db)
            .filter(\.$userID == userID)
            .delete()

        return .noContent
    }
}
