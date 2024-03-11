// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "feather-user-module",
    platforms: [
        .macOS(.v14),
        .iOS(.v17),
        .tvOS(.v17),
        .watchOS(.v10),
        .visionOS(.v1),
    ],
    products: [
        .library(name: "UserSDKInterface", targets: ["UserSDKInterface"]),
        .library(name: "UserSDK", targets: ["UserSDK"]),
        .library(name: "UserSDKMigration", targets: ["UserSDKMigration"]),
        .library(name: "UserOpenAPIGeneratorKit", targets: ["UserOpenAPIGeneratorKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-log", from: "1.5.0"),
        .package(url: "https://github.com/apple/swift-nio", from: "2.61.0"),
        .package(url: "https://github.com/binarybirds/swift-bcrypt", from: "1.0.0"),
        .package(url: "https://github.com/feather-framework/feather-validation", .upToNextMinor(from: "0.1.0")),
        .package(url: "https://github.com/feather-framework/feather-component", .upToNextMinor(from: "0.4.0")),
        .package(url: "https://github.com/feather-framework/feather-mail", .upToNextMinor(from: "0.4.0")),
        .package(url: "https://github.com/feather-framework/feather-mail-driver-memory", .upToNextMinor(from: "0.2.0")),
        .package(url: "https://github.com/feather-framework/feather-relational-database", .upToNextMinor(from: "0.2.0")),
        .package(url: "https://github.com/feather-framework/feather-relational-database-driver-sqlite", .upToNextMinor(from: "0.2.0")),
        .package(url: "https://github.com/feather-framework/feather-openapi-kit", .upToNextMinor(from: "0.8.0")),
        .package(url: "https://github.com/feather-framework/feather-access-control", .upToNextMinor(from: "0.1.0")),
        .package(url: "https://github.com/feather-framework/feather-database-kit", .upToNextMinor(from: "0.3.0")),
        .package(url: "https://github.com/feather-modules/feather-core-module", .upToNextMinor(from: "0.5.1")),
        .package(url: "https://github.com/feather-modules/feather-system-module", .upToNextMinor(from: "0.5.1")),
    ],
    targets: [
        .target(
            name: "UserSDKInterface",
            dependencies: [
                .product(name: "CoreSDKInterface", package: "feather-core-module"),
                .product(name: "SystemSDKInterface", package: "feather-system-module"),
            ]
        ),
        .target(
            name: "UserSDK",
            dependencies: [
                .product(name: "Logging", package: "swift-log"),
                .product(name: "Bcrypt", package: "swift-bcrypt"),
                .product(name: "FeatherValidation", package: "feather-validation"),
                .product(name: "FeatherComponent", package: "feather-component"),
                .product(name: "FeatherMail", package: "feather-mail"),
                .product(name: "FeatherRelationalDatabase", package: "feather-relational-database"),
                .product(name: "DatabaseQueryKit", package: "feather-database-kit"),
                .product(name: "FeatherACL", package: "feather-access-control"),
                .product(name: "SystemSDK", package: "feather-system-module"),
                .target(name: "UserSDKInterface"),
            ]
        ),

        .target(
            name: "UserSDKMigration",
            dependencies: [
                .product(name: "FeatherComponent", package: "feather-component"),
                .product(name: "FeatherMail", package: "feather-mail"),
                .product(name: "FeatherRelationalDatabase", package: "feather-relational-database"),
                .product(name: "DatabaseMigrationKit", package: "feather-database-kit"),
                .product(name: "Bcrypt", package: "swift-bcrypt"),
                .product(name: "SystemSDKMigration", package: "feather-system-module"),
            ]
        ),

        .target(
            name: "UserOpenAPIGeneratorKit",
            dependencies: [
                .product(name: "FeatherOpenAPIKit", package: "feather-openapi-kit"),
                .product(name: "CoreOpenAPIGeneratorKit", package: "feather-core-module"),
                .product(name: "SystemOpenAPIGeneratorKit", package: "feather-system-module"),
            ],
            plugins: [
                .plugin(name: "FeatherOpenAPIGenerator", package: "feather-openapi-kit")
            ]
        ),
        // MARK: - tests
        .testTarget(
            name: "UserSDKInterfaceTests",
            dependencies: [
                .product(name: "NIO", package: "swift-nio"),
                .target(name: "UserSDKInterface")
            ]
        ),
        .testTarget(
            name: "UserSDKTests",
            dependencies: [
                .product(name: "NIO", package: "swift-nio"),
                .target(name: "UserSDK"),
                .target(name: "UserSDKMigration"),
                // drivers
                .product(name: "FeatherMailDriverMemory", package: "feather-mail-driver-memory"),
                .product(name: "FeatherRelationalDatabaseDriverSQLite", package: "feather-relational-database-driver-sqlite"),
            ]
        ),
    ]
)
