//
//  File.swift
//
//
//  Created by Viasz-Kádi Ferenc on 03/02/2024.
//

extension User {

    public enum Push {

        public enum Platform: String, Codable, CaseIterable {
            case android
            case ios
        }

        public struct Create: Codable {
            public let platform: Platform
            public let token: String

            public init(
                platform: Platform,
                token: String
            ) {
                self.platform = platform
                self.token = token
            }
        }

        // MARK: -

        public struct Update: Codable {
            public let token: String

            public init(
                token: String
            ) {
                self.token = token
            }
        }

        public struct Detail: Codable {
            public let platform: Platform
            public let token: String

            public init(
                platform: Platform,
                token: String
            ) {
                self.platform = platform
                self.token = token
            }
        }
    }
}
