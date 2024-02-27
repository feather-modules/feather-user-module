import Hummingbird
import Logging
import OpenAPIHummingbird
import UserInterfaceKit
import UserKit
import UserOpenAPIRuntimeKit
import UserServerKit

extension HBRouter {

    public func config(
        _ sdk: UserInterface
    ) async throws {
        middlewares.add(HBLogRequestsMiddleware(.info))

        let apiGateway = UserAPIGateway(
            sdk: sdk,
            logger: .init(label: "api-gateway")
        )

        try apiGateway.registerHandlers(
            on: self,
            serverURL: Servers.server1(),
            configuration: .init(
                dateTranscoder: CustomDateTranscoder()
            ),
            middlewares: [
                ServerErrorMiddleware(),
                // auth needs to be the last
                //                UserAuthMiddleware(sdk: sdk),
                TestAuthMiddleware(),
            ]
        )
    }
}
