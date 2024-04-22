//
//  File.swift
//
//
//  Created by Tibor Bodecs on 04/12/2023.
//

import FeatherDatabase
import UserModuleKit

extension User.Account {

    public enum Query: DatabaseQuery {
        public typealias Row = Model
    }
}
