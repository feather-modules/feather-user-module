//
//  File.swift
//
//
//  Created by Viasz-Kádi Ferenc on 06/02/2024.
//

import CoreInterfaceKit
import Foundation
import SystemInterfaceKit
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

    public func toSDK(
        permissions: [ID<System.Permission>]
    ) -> User.Auth.Response {
        .init(
            account: account.toSDK(),
            token: token.toSDK(),
            permissions: permissions
        )
    }
}
