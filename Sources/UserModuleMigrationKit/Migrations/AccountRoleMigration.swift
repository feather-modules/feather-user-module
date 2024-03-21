import DatabaseMigrationKit
import MigrationKit
import SQLKit
import UserModuleDatabaseKit
import UserModuleKit

extension User.AccountRole {

    public enum Migrations {

        public struct V1: RelationalDatabaseTableMigration {

            public let tableName: String

            public init() {
                self.tableName = "user_account_role"
            }

            public func statements(
                _ builder: SQLCreateTableBuilder
            ) -> SQLCreateTableBuilder {
                builder
                    .text("account_id")
                    .text("role_key")
                    .unique("account_id", "role_key")
            }
        }
    }
}
