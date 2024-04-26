import FeatherComponent
import FeatherDatabase
import FeatherModuleKit
import FeatherValidation
import NanoID
import UserModuleDatabaseKit
import UserModuleKit

extension User.Account.Model.ColumnNames: ColumnNamesInterface {
    public init(listQuerySortKeys: User.Account.List.Query.Sort.Key) throws {
        switch listQuerySortKeys {
        case .email:
            self = .email
        }
    }
}

extension User.Account.List: ListInterface {
    public init(items: [User.Account.Model], count: UInt) throws {
        try self.init(
            items: items.map {
                .init(id: $0.id, email: $0.email, password: $0.password)
            },
            count: count
        )
    }
}

extension User.Account.List.Query: ListQueryInterface {}

extension User.Account.List.Query.Sort: ListQuerySortInterface {}

extension User.Account.Reference: ReferenceInterface {
    public init(model: User.Account.Model) throws {
        self.init(id: model.id.toID(), email: model.email)
    }
}
