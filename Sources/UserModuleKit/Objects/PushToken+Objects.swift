//
//  File.swift
//
//
//  Created by Viasz-Kádi Ferenc on 03/02/2024.
//

import FeatherModuleKit

extension User.PushToken {

    public enum Platform: String, Object, CaseIterable {
        case android
        case ios
    }

    public struct Create: Object {

        public let accountId: ID<User.Account>
        public let platform: User.PushToken.Platform
        public let token: String

        public init(
            accountId: ID<User.Account>,
            platform: User.PushToken.Platform,
            token: String
        ) {
            self.accountId = accountId
            self.platform = platform
            self.token = token
        }
    }

    public struct Update: Object {

        public let token: String

        public init(token: String) {
            self.token = token
        }
    }

    public struct Detail: Object {

        public let accountId: ID<User.Account>
        public let platform: User.PushToken.Platform
        public let token: String

        public init(
            accountId: ID<User.Account>,
            platform: User.PushToken.Platform,
            token: String
        ) {
            self.accountId = accountId
            self.platform = platform
            self.token = token
        }
    }

}
