//
//  File.swift
//
//
//  Created by Tibor Bodecs on 02/02/2024.
//

import CoreSDKInterface

public protocol UserPasswordInterface {

    func setPassword(
        token: String,
        _ input: UserPasswordSet
    ) async throws

    func resetPassword(
        _ input: UserPasswordReset
    ) async throws

}
