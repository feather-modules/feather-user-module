//
//  File.swift
//
//
//  Created by Tibor Bodecs on 27/02/2024.
//

public struct AccountRoleSeed: Codable {

    enum CodingKeys: String, CodingKey {
        case accountId = "account_id"
        case roleKey = "role_key"
    }

    public let accountId: String
    public let roleKey: String

    public init(accountId: String, roleKey: String) {
        self.accountId = accountId
        self.roleKey = roleKey
    }

}
