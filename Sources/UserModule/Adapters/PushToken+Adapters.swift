import FeatherComponent
import FeatherModuleKit
import FeatherPush
import FeatherValidation
import NanoID
import UserModuleDatabaseKit
import UserModuleKit

extension [User.PushToken.Model] {

    public func toPushRecipient() -> [Recipient] {
        var array: [Recipient] = []
        for item in self {
            array.append(
                .init(
                    token: item.token,
                    platform: Platform.custom(item.platform)
                )
            )
        }
        return array
    }

}

extension User.PushToken.Model: CreateAdapter, UpdateAdapter {
    public init(create: User.PushToken.Create) throws {
        self.init(
            accountId: create.accountId.toKey(),
            platform: create.platform.rawValue,
            token: create.token
        )
    }

    public init(update: User.PushToken.Update, oldModel: Self) throws {
        self.init(
            accountId: oldModel.accountId,
            platform: oldModel.platform,
            token: update.token
        )
    }

}

extension User.PushToken.Detail: DetailAdapter {
    public init(model: User.PushToken.Model) throws {
        self.init(
            accountId: model.accountId.toID(),
            platform: User.PushToken.Platform(rawValue: model.platform)!,
            token: model.token
        )
    }
}

extension User.PushToken.Create: CreateInterface {}

extension User.PushToken.Update: UpdateInterface {}
