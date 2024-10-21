import FeatherComponent
import FeatherDatabase
import FeatherModuleKit
import FeatherValidation
import NanoID
import SystemModuleKit
import UserModuleDatabaseKit
import UserModuleKit

extension User.Account.Model.ColumnNames: ListQuerySortKeyAdapter {
    public init(listQuerySortKeys: User.Account.List.Query.Sort.Key) throws {
        switch listQuerySortKeys {
        case .email:
            self = .email
        case .firstName:
            self = .firstName
        case .lastName:
            self = .lastName
        }
    }
}

extension User.Account.List.Item: ListItemAdapter {
    public init(model: User.Account.Model) throws {
        self.init(
            id: model.id.toID(),
            email: model.email,
            firstName: model.firstName,
            lastName: model.lastName,
            imageKey: model.imageKey
        )
    }
}

extension User.Account.List: ListAdapter {
    public typealias Model = User.Account.Model
}

extension User.Account.Reference: ReferenceAdapter {
    public init(model: User.Account.Model) throws {
        self.init(
            id: model.id.toID(),
            email: model.email,
            firstName: model.firstName,
            lastName: model.lastName,
            imageKey: model.imageKey
        )
    }
}

extension ID<User.Account> {

    func getArrayDataForId(
        _ user: UserModuleInterface,
        _ db: Database
    ) async throws -> (
        [User.Role.Reference], [ID<System.Permission>], [User.Group.Reference]
    ) {
        let roleKeys = try await User.AccountRole.Query
            .listAll(
                filter: .init(
                    column: .accountId,
                    operator: .equal,
                    value: self
                ),
                on: db
            )
            .map { $0.roleKey }
            .map { $0.toID() }
        let permissionKeys = try await User.RolePermission.Query
            .listAll(
                filter: .init(
                    column: .roleKey,
                    operator: .in,
                    value: roleKeys
                ),
                on: db
            )
            .map { $0.permissionKey }
            .map { $0.toID() }
        let roles = try await user.role.reference(ids: roleKeys)

        let groupIds = try await User.AccountGroup.Query
            .listAll(
                filter: .init(
                    column: .accountId,
                    operator: .equal,
                    value: self
                ),
                on: db
            )
            .map { $0.groupId }
            .map { $0.toID() }

        let groups = try await User.Group.Query
            .listAll(
                filter: .init(
                    column: .id,
                    operator: .in,
                    value: groupIds
                ),
                on: db
            )
            .map { $0.toReference() }
        return (roles, permissionKeys, groups)
    }
}

extension User.Account.Model {
    func toListItem() -> User.Account.List.Item {
        .init(
            id: id.toID(),
            email: email,
            firstName: firstName,
            lastName: lastName,
            imageKey: imageKey
        )
    }
}

extension User.Account.Model {
    func toReference() -> User.Account.Reference {
        .init(
            id: id.toID(),
            email: email,
            firstName: firstName,
            lastName: lastName,
            imageKey: imageKey
        )
    }
}
