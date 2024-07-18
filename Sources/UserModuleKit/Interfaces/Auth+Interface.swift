//
//  File.swift
//
//
//  Created by Tibor Bodecs on 02/02/2024.
//

import FeatherModuleKit
import Foundation

public protocol UserAuthInterface: Sendable {

    func auth(
        _ token: String
    ) async throws -> User.Auth.Response

    func auth(
        _ credentials: User.Auth.Request
    ) async throws -> User.Auth.Response

    func authJWT(
        _ email: String,
        _ jwtToken: String,
        _ jwtExpiration: Date
    ) async throws -> User.Auth.Response

    func deleteAuth(_ id: ID<User.Account>) async throws
}
