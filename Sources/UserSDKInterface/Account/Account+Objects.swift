//
//  File.swift
//
//
//  Created by Viasz-Kádi Ferenc on 03/02/2024.
//

import CoreSDKInterface
import SystemSDKInterface

extension User.Account {

    public struct Reference: UserAccountReference {
        public let id: ID<User.Account>
        public let email: String

        public init(
            id: ID<User.Account>,
            email: String
        ) {
            self.id = id
            self.email = email
        }
    }

    //    public enum List {
    //
    //        public enum Sort: String, Codable {
    //            case email
    //        }
    //
    //        public struct Item: Codable {
    //            public let id: ID<User.Account>
    //            public let email: String
    //
    //            public init(
    //                id: ID<User.Account>,
    //                email: String
    //            ) {
    //                self.id = id
    //                self.email = email
    //            }
    //        }
    //    }

    public struct Detail: UserAccountDetail {
        public let id: ID<User.Account>
        public let email: String
        public let roleReferences: [User.Role.Reference]
        public var roles: [UserRoleReference] { roleReferences }

        public init(
            id: ID<User.Account>,
            email: String,
            roleReferences: [User.Role.Reference]
        ) {
            self.id = id
            self.email = email
            self.roleReferences = roleReferences
        }
    }

    public struct Create: UserAccountCreate {
        public let email: String
        public let password: String
        public let roleKeys: [ID<User.Role>]

        public init(
            email: String,
            password: String,
            roleKeys: [ID<User.Role>] = []
        ) {
            self.email = email
            self.password = password
            self.roleKeys = roleKeys
        }

    }
    //
    //    public struct Update: Codable {
    //        public let email: String
    //        public let password: String?
    //        public let roleKeys: [ID<User.Role>]
    //
    //        public init(
    //            email: String,
    //            password: String? = nil,
    //            roleKeys: [ID<User.Role>] = []
    //        ) {
    //            self.email = email
    //            self.password = password
    //            self.roleKeys = roleKeys
    //        }
    //
    //    }
    //
    //    public struct Patch: Codable {
    //        public let email: String?
    //        public let password: String?
    //        public let roleKeys: [ID<User.Role>]?
    //
    //        public init(
    //            email: String? = nil,
    //            password: String? = nil,
    //            roleKeys: [ID<User.Role>]? = nil
    //        ) {
    //            self.email = email
    //            self.password = password
    //            self.roleKeys = roleKeys
    //        }
    //    }
}
