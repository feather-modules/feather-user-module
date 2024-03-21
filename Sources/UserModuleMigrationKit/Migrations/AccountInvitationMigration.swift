import DatabaseMigrationKit
import MigrationKit
import SQLKit
import UserModuleDatabaseKit
import UserModuleKit

extension User.AccountInvitation {

    public enum Migrations {

        public struct V1: RelationalDatabaseTableMigration {

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
}
