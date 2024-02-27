//
//  File.swift
//
//
//  Created by Tibor Bodecs on 06/02/2024.
//

import DatabaseMigrationKit
import MigrationKit
import SQLKit

public struct UserMigrationSeedGroup: MigrationGroup {

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

    public func migrations() -> [Migration] {
        [
            Version1.Initial(
                accounts: accounts,
                roles: roles
            )
        ]
    }
}

extension UserMigrationSeedGroup {
    enum Version1 {}
}
