import DatabaseMigrationKit
import MigrationKit
import SQLKit

extension UserMigrationGroup.Version1 {

    public struct RolePermission: RelationalDatabaseTableMigration {

        public let tableName: String

        public init() {
            self.tableName = "user_role_permission"
        }

        public func statements(
            _ builder: SQLCreateTableBuilder
        ) -> SQLCreateTableBuilder {
            builder
                .text("role_key")
                .text("permission_key")
                .unique("role_key", "permission_key")
        }
    }
}
