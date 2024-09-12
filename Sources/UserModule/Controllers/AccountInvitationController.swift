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
    ControllerReference
{

    typealias Query = User.AccountInvitation.Query
    typealias List = User.AccountInvitation.List
    typealias Reference = User.AccountInvitation.Reference

    let components: ComponentRegistry
    let user: UserModuleInterface

    public init(components: ComponentRegistry, user: UserModuleInterface) {
        self.components = components
        self.user = user
    }

    static let listFilterColumns: [Model.ColumnNames] =
        [
            .email
        ]

    // MARK: -

    func create(
        _ input: User.AccountInvitation.Create
    ) async throws -> User.AccountInvitation.Detail {
        let db = try await components.database().connection()

        try await input.validate(on: db)
        let invitation = User.AccountInvitation.Model(
            id: NanoID.generateKey(),
            email: input.email,
            token: String.generateToken(),
            expiration: Date().addingTimeInterval(86_400 * 7)  // 1 week
        )
        try await User.AccountInvitationTypeSave.Query.insert(
            input.invitationTypeKeys.map {
                User.AccountInvitationTypeSave.Model(
                    invitationtId: invitation.id,
                    typeKey: $0.toKey()
                )
            },
            on: db
        )
        let invitationTypes = try await user.accountInvitationType.reference(
            ids: input.invitationTypeKeys
        )
        
        // send out invitation mail
        try await sendInviteWithMail(invitation, db)

        try await User.AccountInvitation.Query.insert(invitation, on: db)
        return .init(
            id: invitation.id.toID(),
            email: invitation.email,
            token: invitation.token,
            expiration: invitation.expiration,
            invitationTypes: invitationTypes
        )
    }

    func require(_ id: ID<User.AccountInvitation>) async throws
        -> User.AccountInvitation.Detail
    {
        let db = try await components.database().connection()
        guard
            let model = try await User.AccountInvitation.Query.getFirst(
                filter: .init(
                    column: .id,
                    operator: .equal,
                    value: id
                ),
                on: db
            )
        else {
            throw ModuleError.objectNotFound(
                model: String(reflecting: User.AccountInvitation.Model.self),
                keyName: User.AccountInvitation.Model.keyName.rawValue
            )
        }
        let keys = try await User.AccountInvitationTypeSave.Query
            .listAll(
                filter: .init(
                    column: .invitationtId,
                    operator: .equal,
                    value: model.id
                ),
                on: db
            )
            .map { $0.typeKey }
            .map { $0.toID() }

        let invitationTypes = try await user.accountInvitationType.reference(
            ids: keys
        )
        return .init(
            id: model.id.toID(),
            email: model.email,
            token: model.token,
            expiration: model.expiration,
            invitationTypes: invitationTypes
        )
    }

    private func sendInviteWithMail(
        _ model: User.AccountInvitation.Model,
        _ db: Database
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
