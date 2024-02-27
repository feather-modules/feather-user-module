//
//  File.swift
//
//
//  Created by Viasz-Kádi Ferenc on 06/02/2024.
//

import Foundation
import UserInterfaceKit

extension User.Password.Set {

    public func toAPI() -> Components.Schemas.UserPasswordSet {
        .init(password: password)
    }
}

extension User.Password.Reset {

    public func toAPI() -> Components.Schemas.UserPasswordReset {
        .init(email: email)
    }
}
