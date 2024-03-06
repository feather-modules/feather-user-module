//
//  File.swift
//
//
//  Created by Viasz-Kádi Ferenc on 03/02/2024.
//

import CoreSDKInterface
import SystemSDKInterface

public protocol UserPasswordReset {
    var email: String { get }
}

public protocol UserPasswordSet {
    var password: String { get }
}

