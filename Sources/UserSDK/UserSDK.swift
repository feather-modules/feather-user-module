import CoreSDKInterface
import FeatherComponent
import Logging
import SystemSDKInterface
import UserSDKInterface

public struct UserSDK: UserInterface {

    public var system: SystemInterface
    let components: ComponentRegistry
    let logger: Logger

    public init(
        system: SystemInterface,
        components: ComponentRegistry,
        logger: Logger = .init(label: "user-sdk")
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
            system: system,
            role: role,
            logger: logger
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
