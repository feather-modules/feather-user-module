//
//  File.swift
//
//
//  Created by Tibor Bodecs on 07/01/2024.
//

import FeatherDatabase
import UserModuleKit

extension User.Token {

    public enum Query: DatabaseQuery {
        public typealias Row = Model
    }
}
