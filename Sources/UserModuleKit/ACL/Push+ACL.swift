//
//  File.swift
//
//
//  Created by Tibor Bodecs on 28/02/2024.
//

import FeatherACL

extension Permission {

    static func userPush(_ action: Action) -> Self {
        .user("push", action: action)
    }
}

extension User.Push {

    public enum ACL: ACLSet {

        public static let list: Permission = .userPush(.list)
        public static let detail: Permission = .userPush(.detail)
        public static let create: Permission = .userPush(.create)
        public static let delete: Permission = .userPush(.delete)

        public static var all: [Permission] = [
            Self.list,
            Self.detail,
            Self.create,
            Self.delete,
        ]
    }
}
