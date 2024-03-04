import FeatherComponent
import FeatherValidation
import Logging
import SystemInterfaceKit
import UserInterfaceKit

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
        logger: Logger = .init(label: "sdk")
    ) {
        self.system = system
        self.components = components
        self.logger = logger
    }
}
