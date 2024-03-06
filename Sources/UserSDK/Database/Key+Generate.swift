//
//  File.swift
//
//
//  Created by Tibor Bodecs on 20/02/2024.
//

import DatabaseQueryKit
import NanoID

extension Key {

    static func generate() -> Self {
        .init(NanoID().rawValue)
    }
}
