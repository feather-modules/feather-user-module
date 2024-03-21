import DatabaseMigrationKit
import DatabaseQueryKit
import MigrationKit
import SQLKit
import UserModuleDatabaseKit
import UserModuleKit
import XCTest

@testable import UserModuleMigrationKit

struct SeedMigration: RelationalDatabaseMigration {

    func perform(_ db: Database) async throws {

        try await User.Account.Query(db)
            .insert(
                [
                    .init(
                        id: NanoID.generateKey(),
                        email: "test@test.com",
                        password: "ChangeMe1"
                    )
                ]
            )
    }

    func revert(_ db: Database) async throws {

    }
}

struct MyGroup: MigrationGroup {

    func migrations() -> [Migration] {
        [
            SeedMigration()
        ]
    }
}

final class UserModuleMigrationKitTests: TestCase {

    func testSeedMigration() async throws {

        try await migrator.perform(
            groups: User.MigrationGroups.all + [
                MyGroup()
            ]
        )
    }
}
