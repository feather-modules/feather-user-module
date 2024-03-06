//
//  File.swift
//
//
//  Created by Tibor Bodecs on 05/02/2024.
//

import DatabaseQueryKit
import Foundation
import UserSDKInterface

extension String {

    public static func generateToken(_ length: Int = 64) -> String {
        let letters =
            "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map { _ in letters.randomElement()! })
    }
}

extension User.Token.Model {

    static func generate(
        _ accountId: Key<User.Account.Model>
    ) -> Self {
        let value = String.generateToken()
        let now = Date()
        let exp = now.addingTimeInterval(86_400 * 7)  // one week
        return .init(
            value: value,
            accountId: accountId,
            expiration: exp,
            lastAccess: now
        )
    }
}
