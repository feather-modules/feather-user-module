//
//  File.swift
//
//  Created by gerp83 on 23/08/2024
//

import FeatherComponent
import FeatherModuleKit
import FeatherValidation
import NanoID
import UserModuleDatabaseKit
import UserModuleKit

extension User.OauthClient.Model.ColumnNames: ListQuerySortKeyAdapter {
    public init(listQuerySortKeys: User.OauthClient.List.Query.Sort.Key) throws
    {
        switch listQuerySortKeys {
        case .name:
            self = .name
        case .type:
            self = .type
        }
    }
}

extension User.OauthClient.List.Item: ListItemAdapter {
    public init(model: User.OauthClient.Model) throws {
        self.init(
            id: model.id.toID(),
            name: model.name,
            type: User.OauthClient.ClientType(rawValue: model.type)!
        )
    }
}

extension User.OauthClient.List: ListAdapter {
    public typealias Model = User.OauthClient.Model
}

extension User.OauthClient.Reference: ReferenceAdapter {
    public init(model: User.OauthClient.Model) throws {
        self.init(
            id: model.id.toID(),
            name: model.name,
            type: User.OauthClient.ClientType(rawValue: model.type)!
        )
    }
}
