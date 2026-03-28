import Fluent

struct CreateBalanceData: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("balancedata")
            .id()
            .field("userID", .string, .required)
            .field("measurements", .array(of: .custom(BalanceMeasurement.self)), .required)
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("balancedata").delete()
    }
}
