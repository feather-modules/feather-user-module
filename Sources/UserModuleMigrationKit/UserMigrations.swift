import FeatherComponent
import FeatherDatabase
import FeatherScripts
import UserModuleDatabaseKit
import UserModuleKit

extension User {

    public enum Migrations {

        public enum V1: Script {

            public static func run(
                _ components: ComponentRegistry
            ) async throws {
                let db = try await components.database().connection()

                try await Role.Table.create(on: db)
                try await RolePermission.Table.create(on: db)
                try await Account.Table.create(on: db)
                try await AccountRole.Table.create(on: db)
                try await AccountInvitation.Table.create(on: db)
                try await AccountPasswordReset.Table.create(on: db)
                try await Token.Table.create(on: db)
                try await Push.Table.create(on: db)
                try await PushToken.Table.create(on: db)
                try await AuthorizationCode.Table.create(on: db)
                try await OauthClient.Table.create(on: db)
                try await Profile.Table.create(on: db)
            }
        }
    }

}
