//
//  File.swift
//
//
//  Created by Viasz-Kádi Ferenc on 06/02/2024.
//

import Foundation
import UserInterfaceKit

extension User.Auth.Request {

    public func toAPI() -> Components.Schemas.UserAuthRequest {
        .init(
            email: email,
            password: password
        )
    }
}

extension User.Auth.Response {

    public func toAPI() -> Components.Schemas.UserAuthResponse {
        .init(
            account: account.toAPI(),
            token: token.toAPI(),
            roles: roles.map { $0.toAPI() }
        )
    }
}
