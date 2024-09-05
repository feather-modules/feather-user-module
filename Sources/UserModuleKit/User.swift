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
            Account.ACL.all + AccountInvitation.ACL.all
                + AccountInvitationType.ACL.all
                + Password.ACL.all + Push.ACL.all + PushToken.ACL.all
                + Role.ACL.all
                + OauthClient.ACL.all
        }
    }
    
    public enum OauthError: Swift.Error {
        case invalidClient
        case invalidRedirectURI
        case invalidRequest
        case invalidScope
        case invalidGrant
        case unsupportedGrant
        case unauthorizedClient
    }
    
    public enum JWTError: Swift.Error {
        case jwtVerifyFailed
        case jwtUserError
    }

    public enum Error: Swift.Error {
        case unknown
        case invalidPassword
        case invalidAuthToken
        case invalidInvitationToken
        case invalidPasswordResetToken
        case invalidAccount
    }

    public enum Account: Identifiable {}
    public enum AccountInvitation: Identifiable {}
    public enum AccountInvitationType: Identifiable {}
    public enum AccountPasswordReset {}
    public enum AccountRole {}
    public enum Auth {}
    public enum Password {}
    public enum Permission {}
    public enum Push: Identifiable {}
    public enum PushToken: Identifiable {}
    public enum Role: Identifiable {}
    public enum RolePermission {}
    public enum Token: Identifiable {}

    public enum AuthorizationCode: Identifiable {}
    public enum OauthClient: Identifiable {}
    public enum OauthClientRole {}
    public enum Oauth {}
}

public protocol UserModuleInterface: ModuleInterface {

    var account: UserAccountInterface { get }
    var accountInvitation: UserAccountInvitationInterface { get }
    var accountInvitationType: UserAccountInvitationTypeInterface { get }
    var auth: UserAuthInterface { get }
    var password: UserPasswordInterface { get }
    var push: UserPushInterface { get }
    var pushToken: UserPushTokenInterface { get }
    var register: UserRegisterInterface { get }
    var role: UserRoleInterface { get }
    var system: SystemModuleInterface { get }

    var authorizationCode: AuthorizationCodeInterface { get }
    var oauth: UserOauthInterface { get }
    var oauthClient: UserOauthClientInterface { get }
}
