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
        .library(name: "UserModuleKit", targets: ["UserModuleKit"]),
        .library(name: "UserModule", targets: ["UserModule"]),
        .library(name: "UserModuleMigrationKit", targets: ["UserModuleMigrationKit"]),
        .library(name: "UserModuleDatabaseKit", targets: ["UserModuleDatabaseKit"]),
        .library(name: "UserOpenAPIGeneratorKit", targets: ["UserOpenAPIGeneratorKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-log", from: "1.5.0"),
        .package(url: "https://github.com/apple/swift-nio", from: "2.61.0"),
        .package(url: "https://github.com/binarybirds/swift-bcrypt", from: "1.0.0"),
        .package(url: "https://github.com/feather-framework/feather-access-control", .upToNextMinor(from: "0.2.0")),
        .package(url: "https://github.com/feather-framework/feather-validation", .upToNextMinor(from: "0.1.0")),
        .package(url: "https://github.com/feather-framework/feather-component", .upToNextMinor(from: "0.4.0")),
        .package(url: "https://github.com/feather-framework/feather-mail", .upToNextMinor(from: "0.4.0")),
        .package(url: "https://github.com/feather-framework/feather-mail-driver-memory", .upToNextMinor(from: "0.2.0")),
        .package(url: "https://github.com/feather-framework/feather-relational-database", .upToNextMinor(from: "0.2.0")),
        .package(url: "https://github.com/feather-framework/feather-relational-database-driver-sqlite", .upToNextMinor(from: "0.2.0")),
        .package(url: "https://github.com/feather-framework/feather-openapi-kit", .upToNextMinor(from: "0.9.0")),
        .package(url: "https://github.com/feather-framework/feather-database-kit", .upToNextMinor(from: "0.7.0")),
        .package(url: "https://github.com/feather-modules/feather-core-module", .upToNextMinor(from: "0.12.0")),
        .package(url: "https://github.com/feather-modules/feather-system-module", .upToNextMinor(from: "0.11.0")),
    ],
    targets: [
        .target(
            name: "UserModuleKit",
            dependencies: [
                .product(name: "CoreModuleKit", package: "feather-core-module"),
                .product(name: "SystemModuleKit", package: "feather-system-module"),
                .product(name: "FeatherACL", package: "feather-access-control"),
            ]
        ),
        .target(
            name: "UserModuleDatabaseKit",
            dependencies: [
                .target(name: "UserModuleKit"),
                .product(name: "DatabaseQueryKit", package: "feather-database-kit"),
            ]
        ),
        .target(
            name: "UserModule",
            dependencies: [
                .product(name: "Logging", package: "swift-log"),
                .product(name: "Bcrypt", package: "swift-bcrypt"),
                .product(name: "FeatherValidation", package: "feather-validation"),
                .product(name: "FeatherComponent", package: "feather-component"),
                .product(name: "FeatherMail", package: "feather-mail"),
                .product(name: "FeatherRelationalDatabase", package: "feather-relational-database"),
                .product(name: "DatabaseQueryKit", package: "feather-database-kit"),
                .product(name: "FeatherACL", package: "feather-access-control"),
                .product(name: "CoreModule", package: "feather-core-module"),
                .product(name: "SystemModule", package: "feather-system-module"),
                .target(name: "UserModuleKit"),
                .target(name: "UserModuleDatabaseKit"),
            ]
        ),

        .target(
            name: "UserModuleMigrationKit",
            dependencies: [
                .product(name: "FeatherComponent", package: "feather-component"),
                .product(name: "FeatherMail", package: "feather-mail"),
                .product(name: "FeatherRelationalDatabase", package: "feather-relational-database"),
                .product(name: "DatabaseMigrationKit", package: "feather-database-kit"),
                .product(name: "Bcrypt", package: "swift-bcrypt"),
                .product(name: "SystemModuleMigrationKit", package: "feather-system-module"),
                .target(name: "UserModuleDatabaseKit"),
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
            name: "UserModuleKitTests",
            dependencies: [
                .product(name: "NIO", package: "swift-nio"),
                .target(name: "UserModuleKit")
            ]
        ),
        .testTarget(
            name: "UserModuleTests",
            dependencies: [
                .product(name: "NIO", package: "swift-nio"),
                .target(name: "UserModule"),
                .target(name: "UserModuleMigrationKit"),
                // drivers
                .product(name: "FeatherMailDriverMemory", package: "feather-mail-driver-memory"),
                .product(name: "FeatherRelationalDatabaseDriverSQLite", package: "feather-relational-database-driver-sqlite"),
            ]
        ),
    ]
)
