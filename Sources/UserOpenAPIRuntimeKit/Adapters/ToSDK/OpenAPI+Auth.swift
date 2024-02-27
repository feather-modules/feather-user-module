//
//  File.swift
//
//
//  Created by Viasz-Kádi Ferenc on 06/02/2024.
//

import Foundation
import UserInterfaceKit

extension Components.Schemas.UserAuthRequest {

    public func toSDK() -> User.Auth.Request {
        .init(
            email: email,
            password: password
        )
    }
}

extension Components.Schemas.UserAuthResponse {

    public func toSDK() -> User.Auth.Response {
        .init(
            account: account.toSDK(),
            token: token.toSDK(),
            roles: roles.map { $0.toSDK() }
        )
    }
}
