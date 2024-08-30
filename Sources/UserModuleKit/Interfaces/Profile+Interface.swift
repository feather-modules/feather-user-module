import FeatherModuleKit

public protocol UserProfileInterface: Sendable {

    func list(
        _ input: User.Profile.List.Query
    ) async throws -> User.Profile.List

    func reference(
        ids: [ID<User.Account>]
    ) async throws -> [User.Profile.Reference]
    
    func create(
        _ input: User.Profile.Create
    ) async throws -> User.Profile.Detail

    func require(
        _ id: ID<User.Account>
    ) async throws -> User.Profile.Detail

    func update(
        _ id: ID<User.Account>,
        _ input: User.Profile.Update
    ) async throws -> User.Profile.Detail

    func patch(
        _ id: ID<User.Account>,
        _ input: User.Profile.Patch
    ) async throws -> User.Profile.Detail

    func bulkDelete(
        ids: [ID<User.Account>]
    ) async throws
}
