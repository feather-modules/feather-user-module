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

    static func userProfile(_ action: Action) -> Self {
        .user("profile", action: action)
    }
}

extension User.Account {

    public enum ACL: ACLSet {

        // base user
        public static let profileUpdate: Permission = .userProfile(.update)
        public static let profileDelete: Permission = .userProfile(.delete)
        public static let profileDetail: Permission = .userProfile(.detail)
        public static let me: Permission = .userProfile(.custom("me"))

        // manager user
        public static let list: Permission = .userAccount(.list)
        public static let filteredList: Permission = .userAccount(
            .custom("filtered-list")
        )
        public static let update: Permission = .userAccount(.update)
        public static let delete: Permission = .userAccount(.delete)
        public static let detail: Permission = .userAccount(.detail)
        public static let create: Permission = .userAccount(.create)
        public static let password: Permission = .userAccount(
            .custom("password-update")
        )
        public static let managerEdit: Permission = .userAccount(
            .custom("manager-edit")
        )

        public static var all: [Permission] = [
            Self.profileUpdate,
            Self.profileDelete,
            Self.profileDetail,
            Self.me,

            Self.list,
            Self.filteredList,
            Self.update,
            Self.delete,
            Self.detail,
            Self.create,
            Self.password,
            Self.managerEdit,
        ]
    }
}
