//
//  File.swift
//
//  Created by gerp83 on 23/08/2024
//

import FeatherModuleKit
import SystemModuleKit

extension User.OauthClient {

    public enum ClientType: String, Object, CaseIterable {
        case app
        case server
    }

    public struct List: ListInterface {

        public struct Query: ListQueryInterface {

            public struct Sort: ListQuerySortInterface {

                public enum Keys: SortKeyInterface {
                    case name
                    case type
                }

                public let by: Keys
                public let order: Order

                public init(by: Keys, order: Order) {
                    self.by = by
                    self.order = order
                }
            }

            public let search: String?
            public let sort: Sort
            public let page: Page

            public init(
                search: String? = nil,
                sort: User.OauthClient.List.Query.Sort,
                page: Page
            ) {
                self.search = search
                self.sort = sort
                self.page = page
            }
        }

        public struct Item: Object {
            public let id: ID<User.OauthClient>
            public let name: String
            public let type: ClientType

            public init(
                id: ID<User.OauthClient>,
                name: String,
                type: ClientType
            ) {
                self.id = id
                self.name = name
                self.type = type
            }
        }

        public let items: [Item]
        public let count: UInt

        public init(
            items: [User.OauthClient.List.Item],
            count: UInt
        ) {
            self.items = items
            self.count = count
        }

    }

    public struct Reference: Object {
        public let id: ID<User.OauthClient>
        public let name: String
        public let type: ClientType

        public init(
            id: ID<User.OauthClient>,
            name: String,
            type: ClientType
        ) {
            self.id = id
            self.name = name
            self.type = type
        }
    }

    public struct Detail: Object {
        public let id: ID<User.OauthClient>
        public let name: String
        public let type: ClientType
        public let clientSecret: String?
        public let redirectUri: String?
        public let loginRedirectUri: String?
        public let issuer: String
        public let audience: String
        public let privateKey: String
        public let publicKey: String
        public let roles: [User.OauthRole.Reference]?

        public init(
            id: ID<User.OauthClient>,
            name: String,
            type: ClientType,
            clientSecret: String?,
            redirectUri: String?,
            loginRedirectUri: String?,
            issuer: String,
            audience: String,
            privateKey: String,
            publicKey: String,
            roles: [User.OauthRole.Reference]?
        ) {
            self.id = id
            self.name = name
            self.type = type
            self.clientSecret = clientSecret
            self.redirectUri = redirectUri
            self.loginRedirectUri = loginRedirectUri
            self.issuer = issuer
            self.audience = audience
            self.privateKey = privateKey
            self.publicKey = publicKey
            self.roles = roles
        }
    }

    public struct Create: Object {
        public let name: String
        public let type: ClientType
        public let redirectUri: String?
        public let loginRedirectUri: String?
        public let issuer: String
        public let audience: String
        public let roleKeys: [ID<User.OauthRole>]?

        public init(
            name: String,
            type: ClientType,
            redirectUri: String?,
            loginRedirectUri: String?,
            issuer: String,
            audience: String,
            roleKeys: [ID<User.OauthRole>]?
        ) {
            self.name = name
            self.type = type
            self.redirectUri = redirectUri
            self.loginRedirectUri = loginRedirectUri
            self.issuer = issuer
            self.audience = audience
            self.roleKeys = roleKeys
        }
    }

    public struct Update: Object {
        public let name: String
        public let type: ClientType
        public let redirectUri: String?
        public let loginRedirectUri: String?
        public let issuer: String
        public let audience: String
        public let roleKeys: [ID<User.OauthRole>]?

        public init(
            name: String,
            type: ClientType,
            redirectUri: String?,
            loginRedirectUri: String?,
            issuer: String,
            audience: String,
            roleKeys: [ID<User.OauthRole>]?
        ) {
            self.name = name
            self.type = type
            self.redirectUri = redirectUri
            self.loginRedirectUri = loginRedirectUri
            self.issuer = issuer
            self.audience = audience
            self.roleKeys = roleKeys
        }
    }

    public struct Patch: Object {
        public let name: String?
        public let type: ClientType?
        public let redirectUri: String?
        public let loginRedirectUri: String?
        public let issuer: String?
        public let audience: String?
        public let roleKeys: [ID<User.OauthRole>]?

        public init(
            name: String? = nil,
            type: ClientType? = nil,
            redirectUri: String? = nil,
            loginRedirectUri: String? = nil,
            issuer: String? = nil,
            audience: String? = nil,
            roleKeys: [ID<User.OauthRole>]? = nil
        ) {
            self.name = name
            self.type = type
            self.redirectUri = redirectUri
            self.loginRedirectUri = loginRedirectUri
            self.issuer = issuer
            self.audience = audience
            self.roleKeys = roleKeys
        }
    }

}
