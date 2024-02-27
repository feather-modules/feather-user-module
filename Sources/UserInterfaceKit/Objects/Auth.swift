//
//  File.swift
//
//
//  Created by Viasz-Kádi Ferenc on 03/02/2024.
//

extension User.Auth {

    // MARK: -

    public struct Request: Codable {
        public let email: String
        public let password: String

        public init(
            email: String,
            password: String
        ) {
            self.email = email
            self.password = password
        }
    }

    public struct Response: Codable {
        public let account: User.Account.Detail
        public let token: User.Token.Detail
        public let roles: [User.Role.Reference]

        public init(
            account: User.Account.Detail,
            token: User.Token.Detail,
            roles: [User.Role.Reference]
        ) {
            self.account = account
            self.token = token
            self.roles = roles
        }
    }
}
