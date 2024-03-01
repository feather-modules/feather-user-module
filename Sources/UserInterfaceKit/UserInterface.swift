import CoreInterfaceKit
import SystemInterfaceKit

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
    var system: SystemInterface { get }
}
