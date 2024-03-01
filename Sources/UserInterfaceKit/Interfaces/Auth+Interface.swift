//
//  File.swift
//
//
//  Created by Tibor Bodecs on 02/02/2024.
//

import CoreInterfaceKit

public protocol UserAuthInterface {

    func auth(
        _ token: String
    ) async throws -> ACL.AuthenticatedUser

    @discardableResult
    func auth<T>(
        _ token: String,
        _ block: (() async throws -> T)
    ) async throws -> T

    func postAuth(
        _ input: User.Auth.Request
    ) async throws -> User.Auth.Response

    func deleteAuth() async throws
}
