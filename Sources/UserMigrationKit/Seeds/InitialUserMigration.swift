//
//  File.swift
//
//
//  Created by Tibor Bodecs on 27/02/2024.
//

import Bcrypt
import DatabaseMigrationKit
import MigrationKit
import SQLKit

extension UserMigrationSeedGroup.Version1 {

    public struct Initial: RelationalDatabaseMigration {

        public let accounts: [AccountSeed]
        public let roles: [RoleSeed]
        public let accountRoles: [AccountRoleSeed]
        public let rolePermissions: [RolePermissionSeed]

        public init(
            accounts: [AccountSeed] = [],
            roles: [RoleSeed] = [],
            accountRoles: [AccountRoleSeed] = [],
            rolePermissions: [RolePermissionSeed] = []
        ) {
            self.accounts = accounts
            self.roles = roles
            self.accountRoles = accountRoles
            self.rolePermissions = rolePermissions
        }

        public func perform(_ db: SQLDatabase) async throws {

            if !accounts.isEmpty {
                try await db.insert(
                    into: "user_account"
                )
                .models(
                    accounts.map { account in
                        let hashedPassword = try Bcrypt.hash(account.password)
                        return AccountSeed(
                            id: account.id,
                            email: account.email,
                            password: hashedPassword
                        )

                    }
                )
                .run()
            }

            if !roles.isEmpty {
                try await db.insert(
                    into: "user_role"
                )
                .models(roles)
                .run()
            }

            if !accountRoles.isEmpty {
                try await db.insert(
                    into: "user_account_role"
                )
                .models(accountRoles)
                .run()
            }

            if !rolePermissions.isEmpty {
                try await db.insert(
                    into: "user_role_permission"
                )
                .models(rolePermissions)
                .run()
            }
        }

        public func revert(_ db: SQLDatabase) async throws {
            // TODO: delete rows
        }

    }
}
