import FeatherComponent
import FeatherValidation
import Logging
import SystemSDKInterface
import UserSDKInterface

public enum UserSDKError: Error {
    case unknown
    case database(Error)

    case validation([Failure])
}

public struct UserSDK: UserInterface {

    public var system: SystemInterface
    let components: ComponentRegistry
    let logger: Logger

    public init(
        system: SystemInterface,
        components: ComponentRegistry,
        logger: Logger = .init(label: "user-sdk")
    ) {
        self.system = system
        self.components = components
        self.logger = logger
    }
}
