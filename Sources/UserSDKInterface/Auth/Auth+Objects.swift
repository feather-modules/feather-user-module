//
//  File.swift
//
//
//  Created by Tibor Bodecs on 11/03/2024.
//

import CoreSDKInterface
import SystemSDKInterface

extension User.Auth {

    public struct Request: UserAuthRequest {
        public let email: String
        public let password: String

        public init(email: String, password: String) {
            self.email = email
            self.password = password
        }
    }

    public struct Response: UserAuthResponse {
        public let account: UserAccountDetail
        public let token: UserTokenDetail
        public let permissions: [ID<System.Permission>]

        public init(
            account: UserAccountDetail,
            token: UserTokenDetail,
            permissions: [ID<System.Permission>]
        ) {
            self.account = account
            self.token = token
            self.permissions = permissions
        }

    }

}
