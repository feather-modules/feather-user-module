//
//  File.swift
//
//
//  Created by Viasz-Kádi Ferenc on 03/02/2024.
//

import CoreModuleKit
import FeatherACL
import SystemModuleKit

extension Permission {

    static func user(_ context: String, action: Action) -> Self {
        .init(namespace: "user", context: context, action: action)
    }
}

public enum User {

    public enum ACL: ACLSet {

        public static var all: [FeatherACL.Permission] {
            Account.ACL.all + Role.ACL.all + Password.ACL.all
        }
    }

    public enum Error: Swift.Error {
        case unknown
    }

    public enum AccountInvitation {}
    public enum AccountPasswordReset {}
    public enum AccountRole {}
    public enum RolePermission {}

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
