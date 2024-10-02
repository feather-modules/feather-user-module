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
        RoleController(
            components: components,
            user: self
        )
    }

    public var account: UserAccountInterface {
        AccountController(
            components: components,
            user: self
        )
    }

    public var accountRole: UserAccountRoleInterface {
        AccountRoleController(
            components: components,
            user: self
        )
    }

    public var accountInvitation: UserAccountInvitationInterface {
        AccountInvitationController(
            components: components,
            user: self
        )
    }

    public var auth: UserAuthInterface {
        AuthController(
            components: components,
            user: self
        )
    }

    public var password: UserPasswordInterface {
        PasswordController(
            components: components,
            user: self
        )
    }

    public var pushToken: UserPushTokenInterface {
        PushTokenController(
            components: components,
            user: self
        )
    }

    public var push: UserPushInterface {
        PushController(
            components: components,
            user: self
        )
    }

    public var register: UserRegisterInterface {
        RegisterController(
            components: components,
            user: self
        )
    }

    public var accountInvitationType: UserAccountInvitationTypeInterface {
        AccountInvitationTypeController(
            components: components,
            user: self
        )
    }

    public var group: UserGroupInterface {
        GroupController(
            components: components,
            user: self
        )
    }

    public var accountGroup: UserAccountGroupInterface {
        AccountGroupController(
            components: components,
            user: self
        )
    }

}
