//
//  File.swift
//
//
//  Created by Viasz-Kádi Ferenc on 03/02/2024.
//

import CoreSDKInterface
import SystemSDKInterface

public protocol UserAuthRequest {
    var email: String { get }
    var password: String { get }
}

public protocol UserAuthResponse {
    var account: UserAccountDetail { get }
    var token: UserTokenDetail { get }
    var permissions: [ID<System.Permission>] { get }
}

