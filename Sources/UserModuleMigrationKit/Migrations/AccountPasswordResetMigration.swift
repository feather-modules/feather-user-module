import DatabaseMigrationKit
import MigrationKit
import SQLKit
import UserModuleDatabaseKit
import UserModuleKit

extension User.AccountPasswordReset {

    public enum Migrations {

        public struct V1: RelationalDatabaseTableMigration {

            public let tableName: String

            public init() {
                self.tableName = "user_account_password_reset"
            }

            public func statements(
                _ builder: SQLCreateTableBuilder
            ) -> SQLCreateTableBuilder {
                builder
                    .uuid("account_id")
                    .text("token")
                    .date("expiration")
                    .unique("account_id")
            }
        }
    }
}
