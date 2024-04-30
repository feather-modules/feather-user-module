//
//  File.swift
//
//
//  Created by Tibor Bodecs on 04/02/2024.
//

import FeatherComponent
import FeatherDatabase
import FeatherModuleKit
import Foundation
import Logging
import NanoID
import SystemModule
import SystemModuleKit
import UserModuleDatabaseKit
import UserModuleKit

struct AccountInvitationController: UserAccountInvitationInterface,
    ControllerDelete,
    ControllerList,
    ControllerGet
{

    typealias Query = User.AccountInvitation.Query
    typealias List = User.AccountInvitation.List
    typealias Detail = User.AccountInvitation.Detail

    let components: ComponentRegistry
    let user: UserModuleInterface

    public init(
        components: ComponentRegistry,
        user: UserModuleInterface
    ) {
        self.components = components
        self.user = user
    }

    static let listFilterColumns: [Model.ColumnNames] =
        [
            .email
        ]

    // MARK: -

    func create(_ input: User.AccountInvitation.Create) async throws
        -> User.AccountInvitation.Detail
    {
        let db = try await components.database().connection()

        // is email valid and unique
        try await input.validate(on: db)

        // is email already registered
        let hasAccountEmail =
            try await User.Account.Query.getFirst(
                filter:
                    .init(
                        column: .email,
                        operator: .equal,
                        value: input.email
                    ),
                on: db
            ) != nil

        if hasAccountEmail {
            throw User.Error.emailAlreadyInUse
        }

        // create invitation
        let invitation = User.AccountInvitation.Model(
            accountId: input.accountId.toKey(),
            email: input.email,
            token: String.generateToken(),
            expiration: Date().addingTimeInterval(86_400 * 7)  // 1 week
        )

        // TODO: send mail

        // save invitation
        try await User.AccountInvitation.Query.insert(invitation, on: db)
        return .init(
            accountId: invitation.accountId.toID(),
            email: invitation.email,
            token: invitation.token,
            expiration: invitation.expiration
        )

    }

    private func sendInviteWithMail(
        model: User.AccountInvitation.Model,
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

        let content = """
            <h1>Hello.</h1>
            <p>You've been invited to the site \(baseUrl.value) with the following email address: \(model.email).</p>
            <p>You can accept this invitation and create a new account by clicking the link below:</p>

            <p><a href="\(baseUrl.value)register/\(model.token)">Create new account</a></p>

            <p>If you did not request the invitation, feel free to ignore this email.</p>
            <p>Invitation links will expire in one week.</p>
            """

        try await components.mail()
            .send(
                .init(
                    from: .init(systemEmailAddress.value),
                    to: [
                        .init(model.email)
                    ],
                    subject: "Invitation",
                    body: .html(content)
                )
            )
    }

}
