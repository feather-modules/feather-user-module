//
//  File.swift
//
//
//  Created by Tibor Bodecs on 04/02/2024.
//

import FeatherComponent
import FeatherMail
import FeatherModuleKit
import FeatherRelationalDatabase
import Foundation
import Logging
import SystemModuleKit
import UserModuleKit

struct PasswordRepository: UserPasswordInterface {

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

        //        let db = try await components.relationalDatabase().connection()
        //        let qb = User.AccountPasswordReset.Query(db: db)
        //        let accounts = User.Account.Query(db: db)
        //        guard let model = try await qb.firstBy(key: .token, value: token) else {
        //            return  // throw?
        //        }
        //        guard
        //            let account = try await accounts.firstById(
        //                value: model.accountId.rawValue
        //            )
        //        else {
        //            return
        //        }
        //
        //        let updatedAccount = account.updated(try input.sanitized())
        //        try await accounts.update(account.id.rawValue, updatedAccount)
    }

    public func reset(
        _ input: User.Password.Reset
    ) async throws {

        //        let db = try await components.relationalDatabase().connection()
        //        let qb = User.AccountPasswordReset.Query(db: db)
        //
        //        guard
        //            let account = try await User.Account.Query(db: db)
        //                .firstBy(key: .email, value: input.email)
        //        else {
        //            return
        //        }
        //
        //        if let reset = try await qb.firstBy(key: .accountId, value: account.id)
        //        {
        //            try await qb.delete(reset.accountId.rawValue)
        //        }
        //
        //        let token: String = .generateToken()
        //        let expiration = Date().addingTimeInterval(86_400)  // 1 day
        //
        //        try await qb.insert(
        //            User.AccountPasswordReset.Model(
        //                accountId: account.id,
        //                token: token,
        //                expiration: expiration
        //            )
        //        )
        //
        //        // TODO: proper values
        //        let from = "info@binarybirds.com"  // todo system variable
        //        let to = "mail.tib@gmail.com"
        //        //        let to = account.email
        //        let resetLink = "http://localhost:3000/new-password/\(token)"
        //        let subject = "Password reset request"
        //        let content = """
        //            Hello,<br><br>
        //
        //            Click the link below to reset your password.<br><br>
        //
        //            <a href="\(resetLink)">Password reset link</a><br><br>
        //
        //            \(token)<br><br>
        //
        //            NOTE: the link will expire in a day.<br><br>
        //
        //            Bye.<br>
        //            """
        //
        //        try await components.mail()
        //            .send(
        //                .init(
        //                    from: .init(from),
        //                    to: [
        //                        .init(to)
        //                    ],
        //                    subject: subject,
        //                    body: .html(content)
        //                )
        //            )

    }
}
