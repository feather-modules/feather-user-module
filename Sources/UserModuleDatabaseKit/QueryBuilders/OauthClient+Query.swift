//
//  File.swift
//
//  Created by gerp83 on 23/08/2024
//

import FeatherDatabase
import UserModuleKit

extension User.OauthClient {

    public enum Query: DatabaseQuery {
        public typealias Row = Model
    }
}
