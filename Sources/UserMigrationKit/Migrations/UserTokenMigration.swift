import DatabaseMigrationKit
import MigrationKit
import SQLKit

extension UserMigrationGroup.Version1 {

    public struct Token: RelationalDatabaseTableMigration {

        public let tableName: String

        public init() {
            self.tableName = "user_token"
        }

        public func statements(
            _ builder: SQLCreateTableBuilder
        ) -> SQLCreateTableBuilder {
            builder
                .text("value")
                .uuid("account_id")  // user_account reference
                .date("expiration")
                .date("last_access", isMandatory: false)
                .unique("value")
        }
    }
}
