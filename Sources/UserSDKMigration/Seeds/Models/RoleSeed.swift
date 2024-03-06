//
//  File.swift
//
//
//  Created by Tibor Bodecs on 27/02/2024.
//

public struct RoleSeed: Codable {

    public let key: String
    public let name: String
    public let notes: String?

    public init(
        key: String,
        name: String,
        notes: String?
    ) {
        self.key = key
        self.name = name
        self.notes = notes
    }
}
