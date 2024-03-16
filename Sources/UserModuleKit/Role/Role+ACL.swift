//
//  File.swift
//
//
//  Created by Tibor Bodecs on 27/02/2024.
//

import CoreModuleKit

extension Permission {

    static func userRole(_ action: Action) -> Self {
        .user("role", action: action)
    }
}

extension User.Role {

    public enum ACL: ACLSet {

        public static let list: Permission = .userRole(.list)
        public static let detail: Permission = .userRole(.detail)
        public static let create: Permission = .userRole(.create)
        public static let update: Permission = .userRole(.update)
        public static let delete: Permission = .userRole(.delete)

        public static var all: [Permission] = [
            Self.list,
            Self.detail,
            Self.create,
            Self.update,
            Self.delete,
        ]
    }
}
