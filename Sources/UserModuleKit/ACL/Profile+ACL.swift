//
//  File.swift
//
//  Created by gerp83 on 30/08/2024
//
    
import FeatherACL

extension Permission {

    static func userProfile(_ action: Action) -> Self {
        .user("profile", action: action)
    }
}

extension User.Profile {

    public enum ACL: ACLSet {

        public static let list: Permission = .userProfile(.list)
        public static let detail: Permission = .userProfile(.detail)
        public static let update: Permission = .userProfile(.update)
        public static let delete: Permission = .userProfile(.delete)
        public static let me: Permission = .userProfile(.custom("me"))

        public static var all: [Permission] = [
            Self.list,
            Self.detail,
            Self.update,
            Self.delete,
            Self.me,
        ]
    }
}
