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

    public var oauth: UserOauthInterface {
        OauthController(
            components: components,
            user: self
        )
    }

    public var authorizationCode: AuthorizationCodeInterface {
        AuthorizationCodeController(
            components: components,
            user: self
        )
    }

    public var oauthClient: UserOauthClientInterface {
        OauthClientController(
            components: components,
            user: self
        )
    }
    
    public var profile: any UserProfileInterface {
        ProfileController(
            components: components,
            user: self
        )
    }

}
