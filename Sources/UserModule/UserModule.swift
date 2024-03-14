import CoreModuleInterface
import FeatherComponent
import Logging
import SystemModuleInterface
import UserModuleInterface

public struct UserModule: UserInterface {

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
        UserRoleRepository(
            components: components,
            system: system,
            logger: logger
        )
    }

    public var account: UserAccountInterface {
        UserAccountRepository(
            components: components,
            user: self
        )
    }

    public var auth: UserAuthInterface {
        UserAuthRepository(
            components: components,
            system: system,
            role: role,
            logger: logger
        )
    }

    public var profile: UserProfileInterface {
        UserProfileRepository(
            components: components,
            system: system,
            role: role,
            account: account,
            logger: logger
        )
    }

    public var password: UserPasswordInterface {
        UserPasswordRepository(
            components: components,
            system: system,
            role: role,
            account: account,
            logger: logger
        )
    }

    public var push: UserPushInterface {
        UserPushRepository(
            components: components,
            system: system,
            role: role,
            account: account,
            logger: logger
        )
    }

    public var register: UserRegisterInterface {
        UserRegisterRepository(
            components: components,
            system: system,
            role: role,
            account: account,
            logger: logger
        )
    }
}
