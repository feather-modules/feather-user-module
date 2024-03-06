//
//  File.swift
//
//
//  Created by Viasz-Kádi Ferenc on 03/02/2024.
//

import CoreSDKInterface
import SystemSDKInterface

public enum User {

    public enum ACL {

        public static var all: [String] {
            User.Account.ACL.allCases.map(\.rawValue)
                + User.Role.ACL.allCases.map(\.rawValue)
                + User.Password.ACL.allCases.map(\.rawValue)
        }
    }

    //    public enum Error: Swift.Error {
    //        case unknown
    //    }

    public enum Token {}
    public enum PushToken {}
    public enum Auth {}
    public enum Account {}
    public enum Role {}
    public enum Permission {}
    public enum Profile {}
    public enum Password {}
    public enum Push {}
}

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
