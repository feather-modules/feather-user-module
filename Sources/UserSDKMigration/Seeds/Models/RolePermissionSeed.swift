//
//  File.swift
//
//
//  Created by Tibor Bodecs on 27/02/2024.
//

public struct RolePermissionSeed: Codable {

    enum CodingKeys: String, CodingKey {

        case roleKey = "role_key"
        case permissionKey = "permission_key"
    }

    public let roleKey: String
    public let permissionKey: String

    public init(roleKey: String, permissionKey: String) {
        self.roleKey = roleKey
        self.permissionKey = permissionKey
    }
}
