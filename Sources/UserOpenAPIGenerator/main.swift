import FeatherOpenAPIKit
import Foundation
import Yams

let document = OpenAPIDocument()
let encoder = YAMLEncoder()
let openAPIDocument = document.openAPIDocument()
do {
    _ = try openAPIDocument.locallyDereferenced()
}
catch {
    fatalError("\(error)")
}

let yaml = try encoder.encode(openAPIDocument)
let basePath = #file
    .split(separator: "/")
    .dropLast(3)
    .joined(separator: "/")

let paths = [
    "/\(basePath)/openapi/openapi.yaml"
]

for path in paths {
    try yaml.write(
        to: URL(fileURLWithPath: path),
        atomically: true,
        encoding: .utf8
    )
}
