//
//  File.swift
//
//
//  Created by Tibor Bodecs on 28/02/2024.
//

import CoreModuleKit

extension Permission {

    static func userPassword(_ action: Action) -> Self {
        .user("password", action: action)
    }
}

extension User.Password {

    public enum ACL: ACLSet {

        public static let reset: Permission = .userPassword(.custom("reset"))

        public static var all: [Permission] = [
            Self.reset
        ]
    }
}
