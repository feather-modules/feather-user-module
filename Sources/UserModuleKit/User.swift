//
//  File.swift
//
//
//  Created by Viasz-Kádi Ferenc on 03/02/2024.
//

import FeatherACL
import FeatherModuleKit
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
        case invalidPassword
        case invalidAuthToken
        case invalidInvitationToken
        case invalidPasswordResetToken
        case invalidAccount
        case emailAlreadyInUse
    }

    public enum Auth {}
    public enum AccountPasswordReset {}
    public enum AccountRole {}
    public enum RolePermission {}
    public enum Permission {}
    public enum Profile {}
    public enum Password {}
    public enum Token: Identifiable {}

    public enum Account: Identifiable {}
    public enum AccountInvitation: Identifiable {}
    public enum Role: Identifiable {}
    public enum Push: Identifiable {}
    public enum PushToken: Identifiable {}
}

public protocol UserModuleInterface: ModuleInterface {

    var account: UserAccountInterface { get }
    var accountInvitation: UserAccountInvitationInterface { get }
    var profile: UserProfileInterface { get }
    var role: UserRoleInterface { get }
    var auth: UserAuthInterface { get }
    var password: UserPasswordInterface { get }
    var push: UserPushInterface { get }
    var pushToken: UserPushTokenInterface { get }
    var system: SystemModuleInterface { get }
}
