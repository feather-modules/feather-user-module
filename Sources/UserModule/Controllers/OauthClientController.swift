//
//  File.swift
//
//  Created by gerp83 on 23/08/2024
//

import CryptoKit
import FeatherComponent
import FeatherDatabase
import FeatherModuleKit
import Foundation
import Logging
import NanoID
import UserModuleKit

struct OauthClientController: UserOauthClientInterface,
    ControllerDelete,
    ControllerList,
    ControllerGet,
    ControllerReference
{

    typealias Query = User.OauthClient.Query
    typealias Reference = User.OauthClient.Reference
    typealias List = User.OauthClient.List
    typealias Detail = User.OauthClient.Detail

    typealias ControllerModel = User.OauthClient

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

    static let listFilterColumns: [Model.ColumnNames] =
        [
            .name,
            .type,
        ]

    func create(
        _ input: User.OauthClient.Create
    ) async throws -> User.OauthClient.Detail {
        let db = try await components.database().connection()

        let privateKeyData = Curve25519.Signing.PrivateKey()
        let privateKeyBase64 = privateKeyData.rawRepresentation
            .base64EncodedString()
        let publicKeyBase64 = privateKeyData.publicKey.rawRepresentation
            .base64EncodedString()
        var newClientSecret: String? = nil
        var newRedirectUri: String? = input.redirectUri
        var newLoginRedirectUri: String? = input.loginRedirectUri

        if input.type == .server {
            newClientSecret = .generateToken(32)
            newRedirectUri = nil
            newLoginRedirectUri = nil
        }

        let model = User.OauthClient.Model(
            id: NanoID.generateKey(),
            name: input.name,
            type: input.type.rawValue,
            clientSecret: newClientSecret,
            redirectUri: newRedirectUri,
            loginRedirectUri: newLoginRedirectUri,
            issuer: input.issuer,
            subject: input.subject,
            audience: input.audience,
            privateKey: privateKeyBase64,
            publicKey: publicKeyBase64
        )

        try await input.validate(on: db)
        try await User.OauthClient.Query.insert(model, on: db)
        return model.toDetail()
    }

    func update(
        _ id: ID<User.OauthClient>,
        _ input: User.OauthClient.Update
    ) async throws -> User.OauthClient.Detail {
        let db = try await components.database().connection()

        let detail = try await User.OauthClient.Query.require(
            id.toKey(),
            on: db
        )
        try await input.validate(detail.name, on: db)

        let newModel = User.OauthClient.Model(
            id: detail.id,
            name: input.name,
            type: input.type.rawValue,
            clientSecret: detail.clientSecret,
            redirectUri: input.redirectUri,
            loginRedirectUri: input.loginRedirectUri,
            issuer: input.issuer,
            subject: input.subject,
            audience: input.audience,
            privateKey: detail.privateKey,
            publicKey: detail.publicKey
        )
        try await User.OauthClient.Query.update(id.toKey(), newModel, on: db)
        return newModel.toDetail()
    }

    func patch(
        _ id: ID<User.OauthClient>,
        _ input: User.OauthClient.Patch
    ) async throws -> User.OauthClient.Detail {
        let db = try await components.database().connection()

        let oldModel = try await User.OauthClient.Query.require(
            id.toKey(),
            on: db
        )
        try await input.validate(oldModel.name, on: db)

        let newModel = User.OauthClient.Model(
            id: oldModel.id,
            name: input.name ?? oldModel.name,
            type: input.type?.rawValue ?? oldModel.type,
            clientSecret: oldModel.clientSecret,
            redirectUri: input.redirectUri ?? oldModel.redirectUri,
            loginRedirectUri: input.loginRedirectUri
                ?? oldModel.loginRedirectUri,
            issuer: input.issuer ?? oldModel.issuer,
            subject: input.subject ?? oldModel.subject,
            audience: input.audience ?? oldModel.audience,
            privateKey: oldModel.privateKey,
            publicKey: oldModel.publicKey
        )

        try await User.OauthClient.Query.update(id.toKey(), newModel, on: db)
        return newModel.toDetail()
    }

}
