//
//  File.swift
//
//
//  Created by Tibor Bodecs on 06/03/2024.
//

import CoreSDKInterface
import SystemSDKInterface

extension User.Role {

    public struct Reference: UserRoleReference {
        public let key: ID<User.Role>
        public let name: String

        public init(
            key: ID<User.Role>,
            name: String
        ) {
            self.key = key
            self.name = name
        }
    }
}
