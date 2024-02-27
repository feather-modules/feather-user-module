import FeatherComponent
import Foundation
import Logging
import OpenAPIRuntime
import UserInterfaceKit
import UserKit
import UserOpenAPIRuntimeKit

public struct UserAPIGateway: APIProtocol {

    let sdk: UserInterface
    let logger: Logger

    public init(
        sdk: UserInterface,
        logger: Logger = .init(label: "user-api-gateway")
    ) {
        self.sdk = sdk
        self.logger = logger
    }

}
