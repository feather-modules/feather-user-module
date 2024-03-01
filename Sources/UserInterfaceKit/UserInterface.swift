import CoreInterfaceKit

public protocol UserInterface:
    CoreInterface,
    UserAccountInterface,
    UserAccountMeInterface,
    UserAuthInterface,
    UserPasswordInterface,
    UserPushInterface,
    UserRegisterInterface,
    UserRoleInterface
{

}
