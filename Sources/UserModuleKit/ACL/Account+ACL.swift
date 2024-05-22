//
//  File.swift
//
//
//  Created by Tibor Bodecs on 20/02/2024.
//

import FeatherACL

extension Permission {

    static func userAccount(_ action: Action) -> Self {
        .user("account", action: action)
    }
}

extension User.Account {

    public enum ACL: ACLSet {

        public static let list: Permission = .userAccount(.list)
        public static let detail: Permission = .userAccount(.detail)
        public static let create: Permission = .userAccount(.create)
        public static let update: Permission = .userAccount(.update)
        public static let delete: Permission = .userAccount(.delete)
        public static let me: Permission = .userAccount(.custom("me"))

        public static var all: [Permission] = [
            Self.list,
            Self.detail,
            Self.create,
            Self.update,
            Self.delete,
            Self.me,
        ]
    }
}
