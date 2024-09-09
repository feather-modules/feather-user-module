import FeatherComponent
import FeatherDatabase
import FeatherModuleKit
import FeatherValidation
import NanoID
import UserModuleDatabaseKit
import UserModuleKit

extension User.AccountInvitationType.Detail: DetailAdapter {
    public init(model: User.AccountInvitationType.Model) throws {
        self.init(
            key: model.key.toID(),
            title: model.title
        )
    }
}

extension User.AccountInvitationType.Reference: ReferenceAdapter {
    public init(model: User.AccountInvitationType.Model) throws {
        self.init(
            key: model.key.toID(),
            title: model.title
        )
    }
}

extension User.AccountInvitationType.Model.ColumnNames: ListQuerySortKeyAdapter
{
    public init(
        listQuerySortKeys: User.AccountInvitationType.List.Query.Sort.Key
    )
        throws
    {
        switch listQuerySortKeys {
        case .title:
            self = .title
        }
    }
}

extension User.AccountInvitationType.List.Item: ListItemAdapter {
    public init(model: User.AccountInvitationType.Model) throws {
        self.init(key: model.key.toID(), title: model.title)
    }
}

extension User.AccountInvitationType.List: ListAdapter {
    public typealias Model = User.AccountInvitationType.Model
}
