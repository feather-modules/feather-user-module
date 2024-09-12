import FeatherComponent
import FeatherModuleKit
import FeatherValidation
import NanoID
import UserModuleDatabaseKit
import UserModuleKit

extension User.OauthRole.Model.ColumnNames: ListQuerySortKeyAdapter {
    public init(listQuerySortKeys: User.OauthRole.List.Query.Sort.Key) throws
    {
        switch listQuerySortKeys {
        case .key:
            self = .key
        case .name:
            self = .name
        }
    }
}

extension User.OauthRole.List.Item: ListItemAdapter {
    public init(model: User.OauthRole.Model) throws {
        self.init(
            key: model.key.toID(),
            name: model.name
        )
    }
}

extension User.OauthRole.List: ListAdapter {
    public typealias Model = User.OauthRole.Model
}

extension User.OauthRole.Reference: ReferenceAdapter {
    public init(model: User.OauthRole.Model) throws {
        self.init(
            key: model.key.toID(),
            name: model.name
        )
    }
}
