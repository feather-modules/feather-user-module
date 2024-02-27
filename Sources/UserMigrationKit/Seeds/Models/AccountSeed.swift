//
//  File.swift
//
//
//  Created by Tibor Bodecs on 27/02/2024.
//

public struct AccountSeed: Codable {

    public let id: String
    public let email: String
    public let password: String

    public init(
        id: String,
        email: String,
        password: String
    ) {
        self.id = id
        self.email = email
        self.password = password
    }

}
