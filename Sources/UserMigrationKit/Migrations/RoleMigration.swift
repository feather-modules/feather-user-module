import DatabaseMigrationKit
import MigrationKit
import SQLKit

extension UserMigrationGroup.Version1 {

    public struct Role: RelationalDatabaseTableMigration {

        public let tableName: String

        public init() {
            self.tableName = "user_role"
        }

        public func statements(
            _ builder: SQLCreateTableBuilder
        ) -> SQLCreateTableBuilder {
            builder
                .text("key")
                .text("name")
                .text("notes", isMandatory: false)
                .unique("key")
        }
    }
}
