//
//  File.swift
//
//
//  Created by Tibor Bodecs on 02/02/2024.
//

import CoreSDKInterface

public protocol UserAuthInterface {

    func auth(
        _ token: String
    ) async throws -> UserAuthResponse

    func auth(
        _ credentials: UserAuthRequest
    ) async throws -> UserAuthResponse

    func deleteAuth() async throws
}
