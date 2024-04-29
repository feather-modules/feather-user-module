import FeatherComponent
import FeatherModuleKit
import FeatherPush
import FeatherValidation
import NanoID
import UserModuleDatabaseKit
import UserModuleKit

extension Recipient {
   init(model: User.PushToken.Model) {
    self.init(token: model.token, platform: Platform.custom(model.platform))
   }
}

extension [Recipient] {
    init(models: [User.PushToken.Model]) {
        self = models.map { Recipient(model: $0) }
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
