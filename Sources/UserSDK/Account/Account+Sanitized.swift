//
//  File.swift
//
//
//  Created by Tibor Bodecs on 22/02/2024.
//

import Bcrypt
import UserSDKInterface

extension String {

    fileprivate func hash() throws -> Self {
        try Bcrypt.hash(self)
    }
}

extension UserAccountCreate {

    func sanitized() throws -> UserAccountCreate {
        User.Account.Create(
            email: email.lowercased(),
            password: try password.hash(),
            roleKeys: roleKeys
        )
    }
}

extension UserAccountUpdate {

    func sanitized() throws -> UserAccountUpdate {
        fatalError()
        //        User.Account.Update(
        //            email: email.lowercased(),
        //            password: try password.hash(),
        //            roleKeys: roleKeys
        //        )
    }
}

extension UserAccountPatch {

    func sanitized() throws -> UserAccountPatch {
        fatalError()
        //        .init(email: email?.lowercased(), password: try password?.hash())
    }
}

extension UserPasswordSet {

    func sanitized() throws -> UserPasswordSet {
        fatalError()
        //        .init(password: try password.hash())
    }
}
