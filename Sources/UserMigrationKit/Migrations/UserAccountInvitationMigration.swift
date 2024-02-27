import DatabaseMigrationKit
import MigrationKit
import SQLKit

extension UserMigrationGroup.Version1 {

    public struct AccountInvitation: RelationalDatabaseTableMigration {

        public let tableName: String

        public init() {
            self.tableName = "user_account_invitation"
        }

        public func statements(
            _ builder: SQLCreateTableBuilder
        ) -> SQLCreateTableBuilder {
            builder
                .primaryId()
                .text("email")
                .text("token")
                .date("expiration")
                .unique("email")
        }
    }
}
