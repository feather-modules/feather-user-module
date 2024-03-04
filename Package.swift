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
        .library(name: "UserInterfaceKit", targets: ["UserInterfaceKit"]),
        .library(name: "UserOpenAPIRuntimeKit", targets: ["UserOpenAPIRuntimeKit"]),
        .library(name: "UserServerKit", targets: ["UserServerKit"]),
        .library(name: "UserKit", targets: ["UserKit"]),
        .library(name: "UserMigrationKit", targets: ["UserMigrationKit"]),
        .library(name: "UserOpenAPIGeneratorKit", targets: ["UserOpenAPIGeneratorKit"]),
        .executable(name: "UserOpenAPIGenerator", targets: ["UserOpenAPIGenerator"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.2.0"),
        .package(url: "https://github.com/apple/swift-log", from: "1.5.0"),
        .package(url: "https://github.com/apple/swift-nio", from: "2.61.0"),
        .package(url: "https://github.com/apple/swift-openapi-runtime", from: "1.0.0"),
        .package(url: "https://github.com/swift-server/swift-openapi-hummingbird", from: "2.0.0-alpha.2"),
        .package(url: "https://github.com/binarybirds/swift-nanoid", from: "1.0.0"),
        .package(url: "https://github.com/binarybirds/swift-bcrypt", from: "1.0.0"),
        .package(url: "https://github.com/hummingbird-project/hummingbird", from: "2.0.0-alpha.2"),
        .package(url: "https://github.com/feather-framework/feather-validation", .upToNextMinor(from: "0.1.0")),
        .package(url: "https://github.com/feather-framework/feather-component", .upToNextMinor(from: "0.4.0")),
        .package(url: "https://github.com/feather-framework/feather-mail", .upToNextMinor(from: "0.4.0")),
        .package(url: "https://github.com/feather-framework/feather-mail-driver-memory", .upToNextMinor(from: "0.2.0")),
        .package(url: "https://github.com/feather-framework/feather-relational-database", .upToNextMinor(from: "0.2.0")),
        .package(url: "https://github.com/feather-framework/feather-relational-database-driver-sqlite", .upToNextMinor(from: "0.2.0")),
        .package(url: "https://github.com/feather-framework/feather-openapi-spec", .upToNextMinor(from: "0.2.0")),
        .package(url: "https://github.com/feather-framework/feather-openapi-spec-hummingbird", .upToNextMinor(from: "0.3.0")),
        .package(url: "https://github.com/feather-framework/feather-openapi-kit", .upToNextMinor(from: "0.8.0")),
        .package(url: "https://github.com/feather-framework/feather-database-kit", .upToNextMinor(from: "0.1.0")),
        .package(url: "https://github.com/feather-modules/feather-core-module", .upToNextMinor(from: "0.1.0")),
//        .package(url: "https://github.com/feather-modules/feather-system-module", .upToNextMinor(from: "0.2.0")),
        .package(path: "../feather-system-module"),
        .package(url: "https://github.com/jpsim/Yams", from: "5.0.0"),
        
    ],
    targets: [
        .target(
            name: "UserInterfaceKit",
            dependencies: [
                .product(name: "CoreInterfaceKit", package: "feather-core-module"),
                .product(name: "SystemInterfaceKit", package: "feather-system-module"),
            ]
        ),
        .target(
            name: "UserKit",
            dependencies: [
                .product(name: "NIO", package: "swift-nio"),
                .product(name: "Logging", package: "swift-log"),
                .product(name: "NanoID", package: "swift-nanoid"),
                .product(name: "Bcrypt", package: "swift-bcrypt"),
                .product(name: "FeatherValidation", package: "feather-validation"),

                .product(name: "FeatherComponent", package: "feather-component"),
                .product(name: "FeatherMail", package: "feather-mail"),
                .product(name: "FeatherRelationalDatabase", package: "feather-relational-database"),

                .product(name: "DatabaseQueryKit", package: "feather-database-kit"),
                .target(name: "UserInterfaceKit"),
                .product(name: "SystemKit", package: "feather-system-module"),
            ]
        ),

        .target(
            name: "UserOpenAPIRuntimeKit",
            dependencies: [
                .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
                .target(name: "UserInterfaceKit"),
            ]
        ),

        .target(
            name: "UserMigrationKit",
            dependencies: [
                .product(name: "FeatherComponent", package: "feather-component"),
                .product(name: "FeatherMail", package: "feather-mail"),
                .product(name: "FeatherRelationalDatabase", package: "feather-relational-database"),
                .product(name: "DatabaseMigrationKit", package: "feather-database-kit"),
                .product(name: "Bcrypt", package: "swift-bcrypt"),
                .product(name: "SystemMigrationKit", package: "feather-system-module"),
            ]
        ),
        // MARK: - server
        .target(
            name: "UserServerKit",
            dependencies: [
                .target(name: "UserOpenAPIRuntimeKit"),
                .target(name: "UserKit"),
            ]
        ),
        // MARK: - openapi

        .executableTarget(
            name: "UserOpenAPIGenerator",
            dependencies: [
                .product(name: "Yams", package: "Yams"),
                .target(name: "UserOpenAPIGeneratorKit"),
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
            name: "UserInterfaceKitTests",
            dependencies: [
                .target(name: "UserInterfaceKit")
            ]
        ),
        .testTarget(
            name: "UserKitTests",
            dependencies: [
                .target(name: "UserKit"),
                .target(name: "UserMigrationKit"),
                // drivers
                .product(name: "FeatherMailDriverMemory", package: "feather-mail-driver-memory"),
                .product(name: "FeatherRelationalDatabaseDriverSQLite", package: "feather-relational-database-driver-sqlite"),
            ]
        ),
        // MARK: - server tests
        .testTarget(
            name: "UserServerKitTests",
            dependencies: [
                .product(name: "FeatherOpenAPISpec", package: "feather-openapi-spec"),
                .product(name: "FeatherOpenAPISpecHummingbird", package: "feather-openapi-spec-hummingbird"),
                .product(name: "OpenAPIHummingbird", package: "swift-openapi-hummingbird"),
                .target(name: "UserServerKit"),
                .target(name: "UserMigrationKit"),
                // drivers
                .product(name: "FeatherMailDriverMemory", package: "feather-mail-driver-memory"),
                .product(name: "FeatherRelationalDatabaseDriverSQLite", package: "feather-relational-database-driver-sqlite"),
            ]
        ),
    ]
)
