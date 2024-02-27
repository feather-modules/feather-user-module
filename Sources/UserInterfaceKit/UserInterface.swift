import FeatherKit

public protocol UserInterface:
    FeatherInterface,
    UserAccountInterface,
    UserAccountMeInterface,
    UserAuthInterface,
    UserPasswordInterface,
    UserPushInterface,
    UserRegisterInterface,
    UserRoleInterface
{

}
