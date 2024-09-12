//
//  File.swift
//
//  Created by gerp83 on 11/09/2024
//

import FeatherModuleKit
import SystemModuleKit

extension User.AccountRole {

    public struct Detail: Object {
        public let accountId: ID<User.Account>
        public let roleKey: ID<User.Role>

        public init(
            accountId: ID<User.Account>,
            roleKey: ID<User.Role>
        ) {
            self.accountId = accountId
            self.roleKey = roleKey
        }
    }

    public struct Create: Object {
        public let accountId: ID<User.Account>
        public let roleKey: ID<User.Role>

        public init(
            accountId: ID<User.Account>,
            roleKey: ID<User.Role>
        ) {
            self.accountId = accountId
            self.roleKey = roleKey
        }
    }

}
