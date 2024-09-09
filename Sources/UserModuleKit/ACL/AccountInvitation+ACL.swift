//
//  File.swift
//
//
//  Created by Tibor Bodecs on 20/02/2024.
//

import FeatherACL

extension Permission {

    static func userAccountInvitation(_ action: Action) -> Self {
        .user("invitation", action: action)
    }
}

extension User.AccountInvitation {

    public enum ACL: ACLSet {

        public static let list: Permission = .userAccountInvitation(.list)
        public static let detail: Permission = .userAccountInvitation(.detail)
        public static let create: Permission = .userAccountInvitation(.create)
        public static let delete: Permission = .userAccountInvitation(.delete)

        public static var all: [Permission] = [
            Self.list,
            Self.detail,
            Self.create,
            Self.delete,
        ]
    }
}
