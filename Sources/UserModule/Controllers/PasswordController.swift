//
//  File.swift
//
//
//  Created by Tibor Bodecs on 04/02/2024.
//

import FeatherComponent
import FeatherDatabase
import FeatherMail
import FeatherModuleKit
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
        let db = try await components.database().connection()
        // validate reset pasword token
        let passwordReset = try await User.AccountPasswordReset.Query.getFirst(
            filter: .init(
                column: .token,
                operator: .equal,
                value: [token]
            ),
            on: db
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
        guard
            let existingAccount = try await User.Account.Query.getFirst(
                filter: .init(
                    column: .id,
                    operator: .equal,
                    value: [passwordReset.accountId.rawValue]
                ),
                on: db
            )
        else {
            throw User.Error.invalidAccount
        }
        let newModel = User.Account.Model(
            id: existingAccount.id,
            email: existingAccount.email,
            password: input.password,
            firstName: existingAccount.firstName,
            lastName: existingAccount.lastName,
            imageKey: existingAccount.imageKey
        )
        // update with new pasword
        try await User.Account.Query.update(
            existingAccount.id,
            newModel,
            on: db
        )
        //delete pasword reset
        try await User.AccountPasswordReset.Query.delete(
            filter: .init(
                column: .token,
                operator: .in,
                value: [token]
            ),
            on: db
        )
    }

    public func reset(
        _ input: User.Password.Reset
    ) async throws {
        let db = try await components.database().connection()

        //check account exist
        guard
            let existingAccount = try await User.Account.Query.getFirst(
                filter: .init(
                    column: .email,
                    operator: .equal,
                    value: [input.email]
                ),
                on: db
            )
        else {
            return
        }

        // delete previous reset password
        let _ = try await User.AccountPasswordReset.Query.delete(
            filter: .init(
                column: .accountId,
                operator: .equal,
                value: [existingAccount.id]
            ),
            on: db
        )

        // create new password reset
        let newPasswordReset = User.AccountPasswordReset.Model(
            accountId: existingAccount.id,
            token: .generateToken(),
            expiration: Date().addingTimeInterval(86_400)  // 1 day
        )
        try await User.AccountPasswordReset.Query.insert(
            newPasswordReset,
            on: db
        )

        try await sendResetMail(
            email: input.email,
            model: newPasswordReset,
            db: db
        )
    }

    private func sendResetMail(
        email: String,
        model: User.AccountPasswordReset.Model,
        db: Database
    ) async throws {

        // check system values
        guard
            let baseUrl = try await System.Variable.Query.getFirst(
                filter: .init(
                    column: .key,
                    operator: .equal,
                    value: ["baseUrl"]
                ),
                on: db
            )
        else {
            return
        }
        guard
            let systemEmailAddress = try await System.Variable.Query.getFirst(
                filter: .init(
                    column: .key,
                    operator: .equal,
                    value: ["systemEmailAddress"]
                ),
                on: db
            )
        else {
            return
        }

        // create and send mail
        let content = """
            <h1>Hello.</h1>

            <p>We've received a request to reset the password for the account at \(baseUrl.value) associated with \(email).</p>
            <p>No changes have been made to your account yet. You can reset your password by clicking the link below:</p>

            <p><a href="\(baseUrl.value)new-password/\(model.token)">Reset your password</a></p>

            <p>If you did not request a new password, please let us know immediately.</p>
            """
        try await components.mail()
            .send(
                .init(
                    from: .init(systemEmailAddress.value),
                    to: [
                        .init(email)
                    ],
                    subject: "Password reset",
                    body: .html(content)
                )
            )
    }

}
