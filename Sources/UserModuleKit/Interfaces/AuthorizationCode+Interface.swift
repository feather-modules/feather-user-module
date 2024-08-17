import FeatherModuleKit

public protocol AuthorizationCodeInterface: Sendable {

    func create(
        _ input: User.AuthorizationCode.Create
    ) async throws -> User.AuthorizationCode.Detail

    func require(
        _ id: ID<User.AuthorizationCode>
    ) async throws -> User.AuthorizationCode.Detail
    
}
