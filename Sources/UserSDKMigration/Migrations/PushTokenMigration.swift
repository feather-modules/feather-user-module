import DatabaseMigrationKit
import MigrationKit
import SQLKit

extension UserMigrationGroup.Version1 {

    public struct PushToken: RelationalDatabaseTableMigration {

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
