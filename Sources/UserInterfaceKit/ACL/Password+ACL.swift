//
//  File.swift
//
//
//  Created by Tibor Bodecs on 28/02/2024.
//

extension User.Password {

    public enum ACL: String, CaseIterable {
        case list = "user.password.reset"
    }
}
