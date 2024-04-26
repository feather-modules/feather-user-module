import FeatherComponent
import FeatherModuleKit
import FeatherValidation
import NanoID
import UserModuleDatabaseKit
import UserModuleKit

extension User.Role.Model.ColumnNames: ColumnNamesInterface {
    public init(listQuerySortKeys: User.Role.List.Query.Sort.Key) throws {
        switch listQuerySortKeys {
        case .key:
            self = .key
        case .name:
            self = .name
        }
    }
}

extension User.Role.List: ListInterface {
    public init(items: [User.Role.Model], count: UInt) throws {
        try self.init(
            items: items.map {
                .init(key: $0.key, name: $0.name)
            },
            count: count
        )
    }
}

extension User.Role.List.Query: ListQueryInterface {}

extension User.Role.List.Query.Sort: ListQuerySortInterface {}

extension User.Role.Reference: ReferenceInterface {
    public init(model: User.Role.Model) throws {
        self.init(key: model.key.toID(), name: model.name)
    }
}
