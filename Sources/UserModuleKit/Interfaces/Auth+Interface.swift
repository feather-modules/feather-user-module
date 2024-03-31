//
//  File.swift
//
//
//  Created by Tibor Bodecs on 02/02/2024.
//

import FeatherModuleKit

public protocol UserAuthInterface {

    func auth(
        _ token: String
    ) async throws -> User.Auth.Response

    func auth(
        _ credentials: User.Auth.Request
    ) async throws -> User.Auth.Response

    func deleteAuth() async throws
}
