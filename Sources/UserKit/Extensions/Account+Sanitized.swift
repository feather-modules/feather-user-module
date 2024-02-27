//
//  File.swift
//
//
//  Created by Tibor Bodecs on 22/02/2024.
//

import Bcrypt
import UserInterfaceKit

extension String {

    fileprivate func hash() throws -> Self {
        try Bcrypt.hash(self)
    }
}

// NOTE: we might return a new type here...
extension User.Account.Create {

    struct Sanitized: Codable {
        let email: String
        let password: String
    }

    func sanitized() throws -> Sanitized {
        .init(email: email.lowercased(), password: try password.hash())
    }
}

extension User.Account.Update {

    struct Sanitized: Codable {
        let email: String
        let password: String?
    }

    func sanitized() throws -> Sanitized {
        .init(email: email.lowercased(), password: try password?.hash())
    }
}

extension User.Account.Patch {

    struct Sanitized: Codable {
        let email: String?
        let password: String?
    }

    func sanitized() throws -> Sanitized {
        .init(email: email?.lowercased(), password: try password?.hash())
    }
}

extension User.Password.Set {

    struct Sanitized: Codable {
        let password: String
    }

    func sanitized() throws -> Sanitized {
        .init(password: try password.hash())
    }
}
