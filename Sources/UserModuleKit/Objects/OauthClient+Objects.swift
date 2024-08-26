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
        case api
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

    public struct Detail: Object {
        public let id: ID<User.OauthClient>
        public let name: String
        public let type: ClientType
        public let clientSecret: String
        public let redirectUrl: String
        public let issuer: String
        public let subject: String
        public let audience: String
        public let privateKey: String
        public let publicKey: String

        public init(
            id: ID<User.OauthClient>,
            name: String,
            type: ClientType,
            clientSecret: String,
            redirectUrl: String,
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
            self.redirectUrl = redirectUrl
            self.issuer = issuer
            self.subject = subject
            self.audience = audience
            self.privateKey = privateKey
            self.publicKey = publicKey
        }
    }

    public struct Create: Object {
        public let name: String
        public let type: ClientType
        public let redirectUrl: String
        public let issuer: String
        public let subject: String
        public let audience: String

        public init(
            name: String,
            type: ClientType,
            redirectUrl: String,
            issuer: String,
            subject: String,
            audience: String
        ) {
            self.name = name
            self.type = type
            self.redirectUrl = redirectUrl
            self.issuer = issuer
            self.subject = subject
            self.audience = audience
        }
    }

    public struct Update: Object {
        public let name: String
        public let type: ClientType
        public let redirectUrl: String
        public let issuer: String
        public let subject: String
        public let audience: String

        public init(
            name: String,
            type: ClientType,
            redirectUrl: String,
            issuer: String,
            subject: String,
            audience: String
        ) {
            self.name = name
            self.type = type
            self.redirectUrl = redirectUrl
            self.issuer = issuer
            self.subject = subject
            self.audience = audience
        }
    }

    public struct Patch: Object {
        public let name: String?
        public let type: ClientType?
        public let redirectUrl: String?
        public let issuer: String?
        public let subject: String?
        public let audience: String?

        public init(
            name: String? = nil,
            type: ClientType? = nil,
            redirectUrl: String? = nil,
            issuer: String? = nil,
            subject: String? = nil,
            audience: String? = nil
        ) {
            self.name = name
            self.type = type
            self.redirectUrl = redirectUrl
            self.issuer = issuer
            self.subject = subject
            self.audience = audience
        }
    }

}
