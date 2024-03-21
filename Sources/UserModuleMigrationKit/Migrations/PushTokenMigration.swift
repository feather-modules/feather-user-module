import DatabaseMigrationKit
import MigrationKit
import SQLKit
import UserModuleDatabaseKit
import UserModuleKit

extension User.PushToken {

    public enum Migrations {

        public struct V1: RelationalDatabaseTableMigration {

            public let tableName: String

            public init() {
                self.tableName = "user_push_token"
            }

            public func statements(
                _ builder: SQLCreateTableBuilder
            ) -> SQLCreateTableBuilder {
                builder
                    .uuid("account_id")
                    .text("token")
                    .text("platform")
                    .unique("account_id", "token", "platform")
            }
        }
    }
}
