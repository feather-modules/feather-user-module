import FeatherDatabase
import UserModuleDatabaseKit
import UserModuleKit
import XCTest

@testable import UserModuleMigrationKit

final class UserModuleMigrationKitTests: TestCase {

    func testSeedMigration() async throws {
        
        try await scripts.execute([
            User.Migrations.V1.self
        ])
        
        let db = try await components.database().connection()

        try await User.Account.Query
            .insert(
                .init(
                    id: NanoID.generateKey(),
                    email: "test@test.com",
                    password: "ChangeMe1"
                ),
                on: db
            )
        
    }
}
