//
//  File.swift
//
//
//  Created by Tibor Bodecs on 12/03/2024.
//

import CoreModuleKit
import SystemModuleKit

extension User.Password {

    public struct Reset: Object {

        public let email: String

        public init(email: String) {
            self.email = email
        }
    }

    public struct Set: Object {

        public let password: String

        public init(password: String) {
            self.password = password
        }
    }

}
