//
//  File.swift
//
//
//  Created by Viasz-Kádi Ferenc on 06/02/2024.
//

import Foundation
import UserInterfaceKit

extension User.Token.Detail {

    public func toAPI() -> Components.Schemas.UserAuthToken {
        .init(
            value: value.rawValue,
            expiration: expiration
        )
    }
}
