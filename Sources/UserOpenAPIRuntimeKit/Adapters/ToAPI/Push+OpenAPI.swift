//
//  File.swift
//
//
//  Created by Viasz-Kádi Ferenc on 06/02/2024.
//

import Foundation
import UserInterfaceKit

extension User.Push.Platform {

    public func toAPI() -> Components.Schemas.UserPushPlatform {
        switch self {
        case .android:
            return .android
        case .ios:
            return .ios
        }
    }
}

extension User.Push.Create {

    public func toAPI() -> Components.Schemas.UserPushCreate {
        .init(
            platform: platform.toAPI(),
            token: token
        )
    }
}

extension User.Push.Update {

    public func toAPI() -> Components.Schemas.UserPushUpdate {
        .init(token: token)
    }
}

extension User.Push.Detail {

    public func toAPI() -> Components.Schemas.UserPushDetail {
        // TODO: missing param in SDK: id
        // TODO: missing param in SDK: accountId
        .init(
            id: "",
            accountId: "",
            platform: platform.toAPI(),
            token: token
        )
    }
}
