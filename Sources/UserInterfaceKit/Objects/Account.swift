//
//  File.swift
//
//
//  Created by Viasz-Kádi Ferenc on 03/02/2024.
//

import FeatherKit

extension User.Account {

    public struct Reference: Codable {
        public let id: ID<User.Account>
        public let email: String

        public init(id: ID<User.Account>, email: String) {
            self.id = id
            self.email = email
        }
    }

    public enum List {

        public enum Sort: String, Codable {
            case email
        }

        public struct Item: Codable {
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
    }

    public struct Detail: Codable {
        public let id: ID<User.Account>
        public let email: String

        public init(id: ID<User.Account>, email: String) {
            self.id = id
            self.email = email
        }
    }

    public struct Create: Codable {
        public let email: String
        public let password: String

        public init(email: String, password: String) {
            self.email = email
            self.password = password
        }

    }

    public struct Update: Codable {
        public let email: String
        public let password: String?

        public init(
            email: String,
            password: String? = nil
        ) {
            self.email = email
            self.password = password
        }

    }

    public struct Patch: Codable {
        public let email: String?
        public let password: String?

        public init(
            email: String?,
            password: String? = nil
        ) {
            self.email = email
            self.password = password
        }
    }
}
