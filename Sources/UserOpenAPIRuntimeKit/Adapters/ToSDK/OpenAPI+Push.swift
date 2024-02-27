//
//  File.swift
//
//
//  Created by Viasz-Kádi Ferenc on 06/02/2024.
//

import Foundation
import UserInterfaceKit

extension Components.Schemas.UserPushPlatform {

    public func toSDK() -> User.Push.Platform {
        switch self {
        case .android:
            return .android
        case .ios:
            return .ios
        }
    }
}

extension Components.Schemas.UserPushCreate {

    public func toSDK() -> User.Push.Create {
        .init(
            platform: platform.toSDK(),
            token: token
        )
    }
}

extension Components.Schemas.UserPushUpdate {

    public func toSDK() -> User.Push.Update {
        .init(token: token)
    }
}

extension Components.Schemas.UserPushDetail {

    public func toSDK() -> User.Push.Detail {
        .init(
            platform: platform.toSDK(),
            token: token
        )
    }
}
