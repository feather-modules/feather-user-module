//
//  File.swift
//
//
//  Created by Tibor Bodecs on 21/02/2024.
//

import DatabaseQueryKit
import FeatherKit
import UserInterfaceKit

extension ID {

    init(_ key: Key<T>) {
        self.init(key.rawValue)
    }

    func toKey() -> Key<T> {
        .init(rawValue)
    }
}

extension Key {

    init(_ id: ID<T>) {
        self.init(id.rawValue)
    }

    func toID() -> ID<T> {
        .init(rawValue)
    }
}
