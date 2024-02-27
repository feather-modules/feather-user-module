//
//  File.swift
//
//
//  Created by Viasz-Kádi Ferenc on 03/02/2024.
//

extension User {

    public enum Password {

        // MARK: -

        public struct Set: Codable {
            public let password: String

            public init(
                password: String
            ) {
                self.password = password
            }
        }

        // MARK: -

        public struct Reset: Codable {
            public let email: String

            public init(
                email: String
            ) {
                self.email = email
            }
        }
    }
}
