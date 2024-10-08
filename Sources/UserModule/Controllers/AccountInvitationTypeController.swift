//
//  File.swift
//
//  Created by gerp83 on 04/09/2024
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

struct AccountInvitationTypeController: UserAccountInvitationTypeInterface,
    ControllerList,
    ControllerGet,
    ControllerReference
{

    typealias Detail = User.AccountInvitationType.Detail
    typealias Reference = User.AccountInvitationType.Reference
    typealias Query = User.AccountInvitationType.Query
    typealias List = User.AccountInvitationType.List

    let components: ComponentRegistry
    let user: UserModuleInterface

    public init(components: ComponentRegistry, user: UserModuleInterface) {
        self.components = components
        self.user = user
    }

    static let listFilterColumns: [Model.ColumnNames] =
        [
            .title
        ]

    func create(
        _ input: User.AccountInvitationType.Create
    ) async throws -> User.AccountInvitationType.Detail {
        let db = try await components.database().connection()
        try await input.validate(on: db)
        let invitation = User.AccountInvitationType.Model(
            key: input.key.toKey(),
            title: input.title
        )
        try await User.AccountInvitationType.Query.insert(invitation, on: db)
        return .init(
            key: invitation.key.toID(),
            title: invitation.title
        )
    }

}
