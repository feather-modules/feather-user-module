//
//  File.swift
//
//
//  Created by Tibor Bodecs on 04/02/2024.
//

import Bcrypt
import FeatherComponent
import FeatherMail
import FeatherModuleKit
import FeatherDatabase
import Foundation
import Logging
import SystemModule
import SystemModuleKit
import UserModuleKit

struct PasswordController: UserPasswordInterface {

    let components: ComponentRegistry
    let user: UserModuleInterface

    public init(
        components: ComponentRegistry,
        user: UserModuleInterface
    ) {
        self.components = components
        self.user = user
    }

    // MARK: -

    public func set(
        token: String,
        _ input: User.Password.Set
    ) async throws {

        /*let rdb = try await components.relationalDatabase()
        let db = try await rdb.database()

        // validate reset pasword token
        let accountPasswordResetQueryBuilder = User.AccountPasswordReset.Query(
            db: db
        )
        let passwordReset = try await accountPasswordResetQueryBuilder.first(
            filter: .init(
                field: .token,
                operator: .equal,
                value: [token]
            )
        )
        guard
            let passwordReset = passwordReset,
            passwordReset.expiration > Date()
        else {
            throw User.Error.invalidPasswordResetToken
        }

        // validate account
        try await input.validate()
        let input = try input.sanitized()
        let accountQueryBuilder = try await getAccountQueryBuilder()
        guard
            let existingAccount = try await accountQueryBuilder.first(
                filter: .init(
                    field: .id,
                    operator: .equal,
                    value: [passwordReset.accountId.rawValue]
                )
            )
        else {
            throw User.Error.invalidAccount
        }

        let newModel = User.Account.Model(
            id: existingAccount.id,
            email: existingAccount.email,
            password: try Bcrypt.hash(input.password)
        )
        // update with new pasword
        try await accountQueryBuilder.update(existingAccount.id, newModel)
        //delete pasword reset
        try await accountPasswordResetQueryBuilder.delete(
            filter: .init(
                field: .token,
                operator: .in,
                value: [token]
            )
        )*/
        fatalError()
    }

    public func reset(
        _ input: User.Password.Reset
    ) async throws {

        /*let rdb = try await components.relationalDatabase()
        let db = try await rdb.database()

        //check account exist
        let accountQueryBuilder = try await getAccountQueryBuilder()
        guard
            let existingAccount = try await accountQueryBuilder.first(
                filter: .init(
                    field: .email,
                    operator: .equal,
                    value: [input.email]
                )
            )
        else {
            return
        }

        // delete previous reset password
        let accountPasswordResetQueryBuilder = User.AccountPasswordReset.Query(
            db: db
        )
        let _ = try await accountPasswordResetQueryBuilder.delete(
            filter: .init(
                field: .accountId,
                operator: .equal,
                value: [existingAccount.id]
            )
        )

        // check system values
        let systemVariableQueryBuilder = System.Variable.Query(db: db)
        guard
            let baseUrl = try await systemVariableQueryBuilder.first(
                filter: .init(
                    field: .key,
                    operator: .equal,
                    value: ["baseUrl"]
                )
            )
        else {
            return
        }
        guard
            let systemEmailAddress = try await systemVariableQueryBuilder.first(
                filter: .init(
                    field: .key,
                    operator: .equal,
                    value: ["systemEmailAddress"]
                )
            )
        else {
            return
        }

        // create new password reset
        let newPasswordReset = User.AccountPasswordReset.Model(
            accountId: existingAccount.id,
            token: .generateToken(),
            expiration: Date().addingTimeInterval(86_400)  // 1 day
        )
        try await accountPasswordResetQueryBuilder.insert(newPasswordReset)

        // create and send mail
        let content = """
            <h1>Hello.</h1>

            <p>We've received a request to reset the password for the account at \(baseUrl.value) associated with \(input.email).</p>
            <p>No changes have been made to your account yet. You can reset your password by clicking the link below:</p>

            <p><a href="\(baseUrl.value)new-password/\(newPasswordReset.token)">Reset your password</a></p>

            <p>If you did not request a new password, please let us know immediately.</p>
            """
        try await components.mail()
            .send(
                .init(
                    from: .init(systemEmailAddress.value),
                    to: [
                        .init(input.email)
                    ],
                    subject: "Password reset",
                    body: .html(content)
                )
            )*/
        fatalError()
    }

    private func getAccountQueryBuilder() async throws -> User.Account.Query {
        /*let rdb = try await components.relationalDatabase()
        let db = try await rdb.database()
        return .init(db: db)*/
        fatalError()
    }

}
