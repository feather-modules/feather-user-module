//
//  File.swift
//
//
//  Created by Viasz-Kádi Ferenc on 06/02/2024.
//

import Foundation
import UserInterfaceKit

extension Components.Schemas.UserAuthToken {

    public func toSDK() -> User.Token.Detail {
        .init(
            value: .init(value),
            expiration: expiration
        )
    }
}
