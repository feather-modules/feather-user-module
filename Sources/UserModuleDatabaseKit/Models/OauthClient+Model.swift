//
//  File.swift
//
//  Created by gerp83 on 23/08/2024
//

import FeatherDatabase
import UserModuleKit

extension User.OauthClient {

    public struct Model: KeyedDatabaseModel {

        public typealias KeyType = Key<User.OauthClient>

        public enum CodingKeys: String, DatabaseColumnName {
            case id
            case name
            case type
            case clientSecret = "client_secret"
            case redirectUri = "redirect_uri"
            case issuer
            case subject
            case audience
            case privateKey = "private_key"
            case publicKey = "public_key"
        }

        public static let tableName = "user_oauth_client"
        public static let columnNames = CodingKeys.self
        public static let keyName = Model.ColumnNames.id

        public let id: KeyType
        public let name: String
        public let type: String
        public let clientSecret: String
        public let redirectUri: String
        public let issuer: String
        public let subject: String
        public let audience: String
        public let privateKey: String
        public let publicKey: String

        public init(
            id: KeyType,
            name: String,
            type: String,
            clientSecret: String,
            redirectUri: String,
            issuer: String,
            subject: String,
            audience: String,
            privateKey: String,
            publicKey: String
        ) {
            self.id = id
            self.name = name
            self.type = type
            self.clientSecret = clientSecret
            self.redirectUri = redirectUri
            self.issuer = issuer
            self.subject = subject
            self.audience = audience
            self.privateKey = privateKey
            self.publicKey = publicKey
        }
    }
}