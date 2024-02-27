import FeatherOpenAPIKit
import Foundation
import OpenAPIKit
import UserOpenAPIGeneratorKit

struct OpenAPIDocument: Document {

    let components =
        FeatherOpenAPIKit.ComponentCollector.components
        + UserOpenAPIGeneratorKit.ComponentCollector.components

    func openAPIDocument() -> OpenAPI.Document {
        let dateString = DateFormatter.localizedString(
            from: Date(),
            dateStyle: .medium,
            timeStyle: .medium
        )

        return composedDocument(
            info: .init(
                title: "User - API",
                description: """
                    The entire API definition for the user service.
                    (Generated on: \(dateString))
                    """,
                contact: .init(
                    name: "Binary Birds",
                    url: .init(string: "https://binarybirds.com")!,
                    email: "info@binarybirds.com"
                ),
                version: "1.0.0"
            ),
            servers: [
                .init(
                    url: .init(string: "http://localhost:8080")!,
                    description: "dev"
                ),
                .init(
                    url: .init(string: "http://localhost:8081")!,
                    description: "live"
                ),
            ]
        )
    }
}
