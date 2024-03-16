import DatabaseMigrationKit
import MigrationKit
import SQLKit

extension UserMigrationGroup.Version1 {

    public struct Account: RelationalDatabaseTableMigration {

        public let tableName: String

        public init() {
            self.tableName = "user_account"
        }

        public func statements(
            _ builder: SQLCreateTableBuilder
        ) -> SQLCreateTableBuilder {
            builder
                .primaryId()
                .text("email")
                .text("password")
                .unique("email")
        }
    }
}
