import FeatherOpenAPIKit

extension User.Register {

    enum Operations {

        enum Post: Operation {
            static let tag: Tag.Type = Tags.Main.self
            static let summary = "Register account"
            static let description = "Register a new user account"
            static let parameters: [Parameter.Type] = [
                Parameters.Token.self
            ]
            static let requestBody: RequestBody.Type? = RequestBodies.Post.self
            static let responses: [OperationResponse] = [
                .ok(Responses.Post.self)
            ]
        }
    }
}
