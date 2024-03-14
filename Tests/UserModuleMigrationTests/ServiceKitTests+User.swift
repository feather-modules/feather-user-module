//
//  File.swift
//
//
//  Created by Tibor Bodecs on 07/01/2024.
//

import FeatherComponent
import FeatherRelationalDatabase
import FeatherRelationalDatabaseDriverSQLite
import Logging
import NIO
import SQLKit
import UserModuleInterface
import UserModuleMigration
import XCTest

@testable import UserModule

extension ServiceKitTests {

    func runUserAccountModelTest(_ db: SQLDatabase) async throws {
        let qb = User.Account.Query(db: db)

        try await qb.insert(
            .init(
                id: .generate(),
                email: "john@doe.com",
                password: "Password1"
            )
        )

        let list = try await qb.select()

        XCTAssertEqual(list.count, 2)
    }

    func runUserAccountPasswordResetModelTest(_ db: SQLDatabase) async throws {
        let qb = User.AccountPasswordReset.Query(db: db)

        try await qb.insert(
            .init(
                accountId: .generate(),
                token: "foo",
                expiration: .init()
            )
        )

        let list = try await qb.select()

        XCTAssertEqual(list.count, 1)
    }

    func runUserAccountRoleModelTest(_ db: SQLDatabase) async throws {
        let qb = User.AccountRole.Query(db: db)

        try await qb.insert(
            .init(
                accountId: .init(""),
                roleKey: .init("")
            )
        )

        let list = try await qb.select()

        XCTAssertEqual(list.count, 2)
    }

    func runUserInvitationModelTest(_ db: SQLDatabase) async throws {
        let qb = User.AccountInvitation.Query(db: db)

        try await qb.insert(
            .init(
                id: .init(""),
                email: "john@doe.com",
                token: UUID().uuidString,
                expiration: Date()
            )
        )

        let list = try await qb.select()

        XCTAssertEqual(list.count, 1)
    }

    func runUserPushTokenModelTest(_ db: SQLDatabase) async throws {
        let qb = User.PushToken.Query(db: db)

        let accountId = UUID()

        try await qb.insert(
            [
                .init(
                    accountId: accountId,
                    platform: "ios",
                    token: "foo"
                ),
                .init(
                    accountId: accountId,
                    platform: "android",
                    token: "foo"
                ),
            ]
        )

        let list = try await qb.select()

        XCTAssertEqual(list.count, 2)
    }

    func runUserRoleModelTest(_ db: SQLDatabase) async throws {
        let qb = User.Role.Query(db: db)

        try await qb.insert(
            .init(key: .init("manager"), name: "Manager")
        )

        let list = try await qb.select()

        XCTAssertEqual(list.count, 1)
    }

    func runUserRolePermissionModelTest(_ db: SQLDatabase) async throws {
        let qb = User.RolePermission.Query(db: db)

        try await qb.insert(
            .init(
                roleKey: .init("manager"),
                permissionKey: .init("a.b.c")
            )
        )

        let list = try await qb.select()

        XCTAssertEqual(list.count, 1)
    }

    func runUserTokenModelTest(_ db: SQLDatabase) async throws {
        let qb = User.Token.Query(db: db)

        try await qb.insert(
            .init(
                value: "foo",
                accountId: .init("bar"),
                expiration: .init(),
                lastAccess: .init()
            )
        )

        let list = try await qb.select()

        XCTAssertEqual(list.count, 1)
    }
}
