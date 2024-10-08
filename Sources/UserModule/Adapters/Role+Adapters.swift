import FeatherComponent
import FeatherModuleKit
import FeatherValidation
import NanoID
import UserModuleDatabaseKit
import UserModuleKit

extension User.Role.Model.ColumnNames: ListQuerySortKeyAdapter {
    public init(listQuerySortKeys: User.Role.List.Query.Sort.Key) throws {
        switch listQuerySortKeys {
        case .key:
            self = .key
        case .name:
            self = .name
        case .type:
            self = .type
        }
    }
}

extension User.Role.List.Item: ListItemAdapter {
    public init(model: User.Role.Model) throws {
        self.init(
            key: model.key.toID(),
            name: model.name,
            type: model.type.toRoleType()
        )
    }
}

extension User.Role.List: ListAdapter {
    public typealias Model = User.Role.Model
}

extension User.Role.Reference: ReferenceAdapter {
    public init(model: User.Role.Model) throws {
        self.init(key: model.key.toID(), name: model.name)
    }
}
