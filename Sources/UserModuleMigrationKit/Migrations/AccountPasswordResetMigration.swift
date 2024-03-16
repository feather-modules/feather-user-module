import DatabaseMigrationKit
import MigrationKit
import SQLKit

extension UserMigrationGroup.Version1 {

    public struct AccountPasswordReset: RelationalDatabaseTableMigration {

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
