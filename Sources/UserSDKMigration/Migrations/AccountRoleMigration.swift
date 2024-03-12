import DatabaseMigrationKit
import MigrationKit
import SQLKit

extension UserMigrationGroup.Version1 {

    public struct AccountRole: RelationalDatabaseTableMigration {

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
