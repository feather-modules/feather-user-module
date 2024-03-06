//
//  File.swift
//
//
//  Created by Tibor Bodecs on 02/02/2024.
//

import CoreSDKInterface

public protocol UserRegisterInterface {

    func register(
        token: String,
        _ input: UserAccountCreate
    ) async throws -> UserAuthResponse

}
