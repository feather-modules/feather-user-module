//
//  Group+Adapters.swift
//
//  Created by gerp83 on 2024. 10. 01.
//

import FeatherComponent
import FeatherDatabase
import FeatherModuleKit
import FeatherValidation
import NanoID
import SystemModuleKit
import UserModuleDatabaseKit
import UserModuleKit

extension User.Group.Model.ColumnNames: ListQuerySortKeyAdapter {
    public init(listQuerySortKeys: User.Group.List.Query.Sort.Key) throws {
        switch listQuerySortKeys {
        case .name:
            self = .name
        }
    }
}

extension User.Group.List.Item: ListItemAdapter {
    public init(model: User.Group.Model) throws {
        self.init(
            id: model.id.toID(),
            name: model.name
        )
    }
}

extension User.Group.List: ListAdapter {
    public typealias Model = User.Group.Model
}

extension User.Group.Reference: ReferenceAdapter {
    public init(model: User.Group.Model) throws {
        self.init(
            id: model.id.toID(),
            name: model.name
        )
    }
}

extension User.Group.Detail: DetailAdapter {
    public init(model: User.Group.Model) throws {
        self.init(
            id: model.id.toID(),
            name: model.name
        )
    }
}

extension User.Group.Model {
    func toDetail() -> User.Group.Detail {
        .init(id: self.id.toID(), name: self.name)
    }

}
