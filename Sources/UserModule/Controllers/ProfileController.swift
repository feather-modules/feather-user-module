import FeatherComponent
import FeatherDatabase
import FeatherModuleKit
import Logging
import NanoID
import UserModuleDatabaseKit
import UserModuleKit

struct ProfileController: UserProfileInterface,
    ControllerDelete,
    ControllerList,
    ControllerReference
{
    typealias Query = User.Profile.Query
    typealias Reference = User.Profile.Reference
    typealias List = User.Profile.List

    let components: ComponentRegistry
    let user: UserModuleInterface

    public init(
        components: ComponentRegistry,
        user: UserModuleInterface
    ) {
        self.components = components
        self.user = user
    }

    static let listFilterColumns: [Model.ColumnNames] =
        [
            .firstName,
            .lastName
        ]
    
    func create(
        _ input: User.Profile.Create
    ) async throws -> User.Profile.Detail {
        let db = try await components.database().connection()
        
        let model = User.Profile.Model(
            accountId: input.accountId.toKey(),
            firstName: input.firstName,
            lastName: input.lastName,
            imageKey: input.imageKey,
            position: input.position,
            publicEmail: input.publicEmail,
            phone: input.phone,
            web: input.web,
            lat: input.lat,
            lon: input.lon,
            lastLocationUpdate: input.lastLocationUpdate
           
        )
        try await User.Profile.Query.insert(model, on: db)
        return model.toDetail()
    }

    func require(
        _ id: FeatherModuleKit.ID<User.Account>
    ) async throws -> User.Profile.Detail {
        let db = try await components.database().connection()
        let model = try await User.Profile.Query.require(id.toKey(), on: db)
        return model.toDetail()
    }
    
    func update(
        _ id: ID<User.Account>,
        _ input: User.Profile.Update
    ) async throws -> User.Profile.Detail {
        let db = try await components.database().connection()
        let oldModel = try await User.Profile.Query.require(id.toKey(), on: db)
        let newModel = User.Profile.Model(
            accountId: oldModel.accountId,
            firstName: input.firstName,
            lastName: input.lastName,
            imageKey: input.imageKey,
            position: input.position,
            publicEmail: input.publicEmail,
            phone: input.phone,
            web: input.web,
            lat: input.lat,
            lon: input.lon,
            lastLocationUpdate: input.lastLocationUpdate
        )
        try await User.Profile.Query.update(id.toKey(), newModel, on: db)
        return newModel.toDetail()
    }

    func patch(
        _ id: ID<User.Account>,
        _ input: User.Profile.Patch
    ) async throws -> User.Profile.Detail {
        let db = try await components.database().connection()
        let oldModel = try await User.Profile.Query.require(id.toKey(), on: db)
        
        let newModel = User.Profile.Model(
            accountId: oldModel.accountId,
            firstName: input.firstName ?? oldModel.firstName,
            lastName: input.lastName ?? oldModel.lastName,
            imageKey: input.imageKey ?? oldModel.imageKey,
            position: input.position ?? oldModel.position,
            publicEmail: input.publicEmail ?? oldModel.publicEmail,
            phone: input.phone ?? oldModel.phone,
            web: input.web ?? oldModel.web,
            lat: input.lat ?? oldModel.lat,
            lon: input.lon ?? oldModel.lon,
            lastLocationUpdate: input.lastLocationUpdate ?? oldModel.lastLocationUpdate
        )
        
        try await User.Profile.Query.update(id.toKey(), newModel, on: db)
        return newModel.toDetail()
    }
    
}
