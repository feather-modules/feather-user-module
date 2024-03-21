import DatabaseMigrationKit
import MigrationKit
import UserModuleDatabaseKit
import UserModuleKit

extension User {

    public enum MigrationGroups {

        public static var all: [MigrationGroup] {
            [
                Structural()
            ]
        }

        public struct Structural: MigrationGroup {

            public init() {}

            public func migrations() -> [Migration] {
                [
                    Role.Migrations.V1(),
                    RolePermission.Migrations.V1(),
                    Account.Migrations.V1(),
                    AccountRole.Migrations.V1(),
                    AccountInvitation.Migrations.V1(),
                    AccountPasswordReset.Migrations.V1(),
                    Token.Migrations.V1(),
                    PushToken.Migrations.V1(),
                ]
            }
        }
    }
}
