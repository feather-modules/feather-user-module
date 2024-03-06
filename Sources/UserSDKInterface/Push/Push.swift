//
//  File.swift
//
//
//  Created by Viasz-Kádi Ferenc on 03/02/2024.
//

import CoreSDKInterface

extension User.Push: Identifiable {}

extension User.Push {

    public enum Platform: String, Codable, CaseIterable {
        case android
        case ios
    }
}

public protocol UserPushCreate {
    var platform: User.Push.Platform { get }
    var token: String { get }
}

public protocol UserPushUpdate {
    var token: String { get }
}

public protocol UserPushDetail {
    var id: ID<User.Push> { get }
    var platform: User.Push.Platform { get }
    var token: String { get }
}
