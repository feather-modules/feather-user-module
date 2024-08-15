//
//  File.swift
//
//  Created by gerp83 on 15/08/2024
//
    
import FeatherACL

extension Permission {

    static func oauth2(_ action: Action) -> Self {
        .user("oauth2", action: action)
    }
}

extension User.Oauth2 {

    public enum ACL: ACLSet {

        public static let getCode: Permission = .oauth2(.custom("getCode"))
        public static let exchangeCode: Permission = .oauth2(.custom("exchangeCode"))

        public static var all: [Permission] = [
            Self.getCode,
            Self.exchangeCode,
        ]
    }
}
