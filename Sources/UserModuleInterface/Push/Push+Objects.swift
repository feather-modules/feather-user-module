//
//  File.swift
//
//
//  Created by Viasz-Kádi Ferenc on 03/02/2024.
//

import CoreModuleInterface

extension User.Push {

    public enum Platform: String, Object, CaseIterable {
        case android
        case ios
    }

    public struct Create: Object {

        public let platform: User.Push.Platform
        public let token: String

        public init(platform: User.Push.Platform, token: String) {
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

        public let id: ID<User.Push>
        public let platform: User.Push.Platform
        public let token: String

        public init(
            id: ID<User.Push>,
            platform: User.Push.Platform,
            token: String
        ) {
            self.id = id
            self.platform = platform
            self.token = token
        }
    }

}
