import FeatherComponent
import FeatherModuleKit
import Logging
import SystemModuleKit
import UserModuleKit

public struct UserModule: UserModuleInterface {

    public let system: SystemModuleInterface
    let components: ComponentRegistry
    let logger: Logger

    public init(
        system: SystemModuleInterface,
        components: ComponentRegistry,
        logger: Logger = .init(label: "user-Module")
    ) {
        self.system = system
        self.components = components
        self.logger = logger
    }

    public var role: UserRoleInterface {
        RoleRepository(
            components: components,
            user: self
        )
    }

    public var account: UserAccountInterface {
        AccountRepository(
            components: components,
            user: self
        )
    }

    public var auth: UserAuthInterface {
        AuthRepository(
            components: components,
            user: self
        )
    }

    public var profile: UserProfileInterface {
        ProfileRepository(
            components: components,
            user: self
        )
    }

    public var password: UserPasswordInterface {
        PasswordRepository(
            components: components,
            user: self
        )
    }

    public var push: UserPushInterface {
        PushRepository(
            components: components,
            user: self
        )
    }

    public var register: UserRegisterInterface {
        RegisterRepository(
            components: components,
            user: self
        )
    }
}
