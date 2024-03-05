//
//  File.swift
//
//
//  Created by Viasz-Kádi Ferenc on 03/02/2024.
//

import CoreInterfaceKit
import SystemInterfaceKit

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
        public let permissions: [ID<System.Permission>]

        public init(
            account: User.Account.Detail,
            token: User.Token.Detail,
            permissions: [ID<System.Permission>]
        ) {
            self.account = account
            self.token = token
            self.permissions = permissions
        }
    }
}
