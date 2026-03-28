import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get("healthcheck") { req async -> String in
        "Up and running."
    }

    try app.register(collection: BalanceDataController())
    app.routes.defaultMaxBodySize = "5MB"
}
