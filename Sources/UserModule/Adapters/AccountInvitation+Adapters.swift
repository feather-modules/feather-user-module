import FeatherComponent
import FeatherDatabase
import FeatherModuleKit
import FeatherValidation
import NanoID
import UserModuleDatabaseKit
import UserModuleKit

extension User.AccountInvitation.Model.ColumnNames: ListQuerySortKeyAdapter {
    public init(listQuerySortKeys: User.AccountInvitation.List.Query.Sort.Key)
        throws
    {
        switch listQuerySortKeys {
        case .email:
            self = .email
        }
    }
}

extension User.AccountInvitation.List.Item: ListItemAdapter {
    public init(model: User.AccountInvitation.Model) throws {
        self.init(accountId: model.accountId.toID(), email: model.email)
    }
}

extension User.AccountInvitation.List: ListAdapter {
    public typealias Model = User.AccountInvitation.Model
}

extension User.AccountInvitation.Detail: DetailAdapter {
    public init(model: User.AccountInvitation.Model) throws {
        self.init(
            accountId: model.accountId.toID(),
            email: model.email,
            token: model.token,
            expiration: model.expiration
        )
    }
}
