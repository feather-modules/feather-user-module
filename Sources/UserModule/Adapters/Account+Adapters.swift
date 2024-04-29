import FeatherComponent
import FeatherDatabase
import FeatherModuleKit
import FeatherValidation
import NanoID
import UserModuleDatabaseKit
import UserModuleKit

extension User.Account.Model.ColumnNames: ListQuerySortKeyAdapter {
    public init(listQuerySortKeys: User.Account.List.Query.Sort.Key) throws {
        switch listQuerySortKeys {
        case .email:
            self = .email
        }
    }
}

extension User.Account.List.Item: ListItemAdapter {
    public init(model: User.Account.Model) throws {
        self.init(id: model.id.toID(), email: model.email)
    }
}

extension User.Account.List: ListAdapter {
    public typealias Model = User.Account.Model
}

extension User.Account.Reference: ReferenceAdapter {
    public init(model: User.Account.Model) throws {
        self.init(id: model.id.toID(), email: model.email)
    }
}
