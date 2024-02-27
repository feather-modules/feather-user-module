import DatabaseMigrationKit
import MigrationKit
import SQLKit

public struct UserMigrationGroup: MigrationGroup {

    public init() {}

    public func migrations() -> [Migration] {
        [
            Version1.Role(),
            Version1.RolePermission(),
            Version1.Account(),
            Version1.AccountRole(),
            Version1.AccountInvitation(),
            Version1.AccountPasswordReset(),
            Version1.Token(),
            Version1.PushToken(),
        ]
    }
}

extension UserMigrationGroup {
    public enum Version1 {}
}
