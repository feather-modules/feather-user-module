//
//  File.swift
//
//
//  Created by Viasz-Kádi Ferenc on 06/02/2024.
//

import Foundation
import UserInterfaceKit

extension Components.Schemas.UserPasswordSet {

    public func toSDK() -> User.Password.Set {
        .init(password: password)
    }
}

extension Components.Schemas.UserPasswordReset {

    public func toSDK() -> User.Password.Reset {
        .init(email: email)
    }
}
