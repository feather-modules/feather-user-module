import FeatherComponent
import FeatherValidation
import Logging
import UserInterfaceKit

public enum UserSDKError: Error {
    case unknown
    case database(Error)

    case validation([Failure])
}

public struct UserSDK: UserInterface {

    let components: ComponentRegistry
    let logger: Logger

    public init(
        components: ComponentRegistry,
        logger: Logger = .init(label: "sdk")
    ) {
        self.components = components
        self.logger = logger
    }
}
