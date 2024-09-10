//
//  File.swift
//
//
//  Created by Tibor Bodecs on 11/03/2024.
//

import FeatherModuleKit
import SystemModuleKit

extension User.Auth {

    public struct Request: Object {
        public let email: String
        public let password: String

        public init(email: String, password: String) {
            self.email = email
            self.password = password
        }
    }

    public struct Response: Object {
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
