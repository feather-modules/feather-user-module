//
//  File.swift
//
//
//  Created by Tibor Bodecs on 28/02/2024.
//

import FeatherACL

extension Permission {

    static func userPassword(_ action: Action) -> Self {
        .user("profile", action: action)
    }
}

extension User.Password {

    public enum ACL: ACLSet {
        
        public static let update: Permission = .userPassword(.custom("password-update"))
        public static let reset: Permission = .userPassword(.custom("reset-password"))

        public static var all: [Permission] = [
            Self.update,
            Self.reset
        ]
    }
}
