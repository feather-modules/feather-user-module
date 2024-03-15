import CoreModuleInterface
import FeatherComponent
import Logging
import SystemModuleInterface
import UserModuleInterface

public struct UserModule: UserModuleInterface {

    public var system: SystemModuleInterface
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
