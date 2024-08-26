//
//  File.swift
//
//  Created by gerp83 on 17/08/2024
//

import FeatherACL
import FeatherComponent
import FeatherDatabase
import FeatherModuleKit
import Foundation
import NanoID
import SQLKit
import UserModuleKit

struct AuthorizationCodeController: AuthorizationCodeInterface {

    let components: ComponentRegistry
    let user: UserModuleInterface

    public init(
        components: ComponentRegistry,
        user: UserModuleInterface
    ) {
        self.components = components
        self.user = user
    }

    func create(_ input: User.AuthorizationCode.Create) async throws
        -> User.AuthorizationCode.Detail
    {
        let db = try await components.database().connection()
        let newCode = String.generateToken()
        let model = User.AuthorizationCode.Model(
            id: NanoID.generateKey(),
            expiration: Date().addingTimeInterval(600),
            value: newCode,
            accountId: input.accountId.toKey(),
            clientId: input.clientId,
            redirectUrl: input.redirectUrl,
            scope: input.scope,
            state: input.state,
            codeChallenge: input.codeChallenge,
            codeChallengeMethod: input.codeChallengeMethod
        )
        try await User.AuthorizationCode.Query.insert(model, on: db)
        return model.toDetail()
    }

    func require(_ id: ID<User.AuthorizationCode>) async throws
        -> User.AuthorizationCode.Detail
    {
        let db = try await components.database().connection()
        guard
            let model = try await User.AuthorizationCode.Query.getFirst(
                filter: .init(
                    column: .id,
                    operator: .is,
                    value: id
                ),
                on: db
            )
        else {
            throw ModuleError.objectNotFound(
                model: String(reflecting: User.AuthorizationCode.Model.self),
                keyName: User.AuthorizationCode.Model.keyName.rawValue
            )
        }
        return model.toDetail()
    }

}

extension User.AuthorizationCode.Model {

    func toDetail() -> User.AuthorizationCode.Detail {
        User.AuthorizationCode.Detail(
            id: self.id.toID(),
            expiration: self.expiration,
            value: self.value,
            accountId: self.accountId.toID(),
            clientId: self.clientId,
            redirectUrl: self.redirectUrl,
            scope: self.scope,
            state: self.state,
            codeChallenge: self.codeChallenge,
            codeChallengeMethod: self.codeChallengeMethod
        )
    }

}
