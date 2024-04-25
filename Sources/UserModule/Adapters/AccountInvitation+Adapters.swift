import FeatherComponent
import FeatherDatabase
import FeatherModuleKit
import FeatherValidation
import NanoID
import UserModuleDatabaseKit
import UserModuleKit

extension User.AccountInvitation.Model.ColumnNames: ModelColumnNamesInterface {
    public init(listQuerySortKeys: User.AccountInvitation.List.Query.Sort.Key)
        throws
    {
        switch listQuerySortKeys {
        case .email:
            self = .email
        }
    }
}

extension User.AccountInvitation.List: ListInterface {
    public init(items: [User.AccountInvitation.Model], count: UInt) throws {
        self.init(
            items: items.map {
                .init(accountId: $0.accountId.toID(), email: $0.email)
            },
            count: count
        )
    }
}

extension User.AccountInvitation.Detail: DetailInterface {
    public init(model: User.AccountInvitation.Model) throws {
        self.init(
            accountId: model.accountId.toID(),
            email: model.email,
            token: model.token,
            expiration: model.expiration
        )
    }
}

extension User.AccountInvitation.List.Query: ListQueryInterface {}

extension User.AccountInvitation.List.Query.Sort: ListQuerySortInterface {}
