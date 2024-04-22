//
//  File.swift
//
//
//  Created by Tibor Bodecs on 06/01/2024.
//

import FeatherDatabase
import UserModuleKit

extension User.Role {

    public enum Query: DatabaseQuery {
        public typealias Row = Model
    }
}
