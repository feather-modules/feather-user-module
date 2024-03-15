//
//  File.swift
//
//
//  Created by Viasz-Kádi Ferenc on 03/02/2024.
//

import CoreModuleInterface
import SystemModuleInterface

public enum User {

    public enum ACL {

        public static var all: [String] {
            User.Account.ACL.allCases.map(\.rawValue)
                + User.Role.ACL.allCases.map(\.rawValue)
                + User.Password.ACL.allCases.map(\.rawValue)
        }
    }

    public enum Error: Swift.Error {
        case unknown
    }

    public enum Token: Identifiable {}
    public enum PushToken {}
    public enum Auth {}
    public enum Account: Identifiable {}
    public enum Role: Identifiable {}
    public enum Permission {}
    public enum Profile {}
    public enum Password {}
    public enum Push: Identifiable {}
}

public protocol UserModuleInterface: ModuleInterface {

    var system: SystemModuleInterface { get }

    var account: UserAccountInterface { get }
    var profile: UserProfileInterface { get }
    var role: UserRoleInterface { get }
    var auth: UserAuthInterface { get }
    var password: UserPasswordInterface { get }
}
