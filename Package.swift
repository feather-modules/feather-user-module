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
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-nio", from: "2.61.0"),
        .package(url: "https://github.com/binarybirds/swift-bcrypt", from: "1.0.2"),
        .package(url: "https://github.com/feather-framework/feather-mail-driver-memory", .upToNextMinor(from: "0.3.0")),
        .package(url: "https://github.com/feather-framework/feather-push-driver-memory", .upToNextMinor(from: "0.4.0")),
        .package(url: "https://github.com/feather-framework/feather-database-driver-sqlite", .upToNextMinor(from: "0.4.0")),
        .package(url: "https://github.com/feather-framework/feather-module-kit", .upToNextMinor(from: "0.5.0")),
        .package(url: "https://github.com/feather-modules/feather-system-module", .upToNextMinor(from: "0.17.0")),
        .package(url: "https://github.com/feather-framework/feather-validation", .upToNextMinor(from: "0.1.1")),
        .package(url: "https://github.com/feather-framework/feather-access-control", .upToNextMinor(from: "0.2.0")),
        .package(url: "https://github.com/vapor/jwt-kit.git", exact: "5.0.0-rc.2"),
    ],
    targets: [
        .target(
            name: "UserModuleKit",
            dependencies: [
                .product(name: "JWTKit", package: "jwt-kit"),
                .product(name: "FeatherModuleKit", package: "feather-module-kit"),
                .product(name: "SystemModuleKit", package: "feather-system-module"),
                .product(name: "FeatherACL", package: "feather-access-control"),
            ]
        ),
        .target(
            name: "UserModuleDatabaseKit",
            dependencies: [
                .target(name: "UserModuleKit"),
            ]
        ),
        .target(
            name: "UserModule",
            dependencies: [
                //.product(name: "Crypto", package: "swift-crypto"),
                .product(name: "JWTKit", package: "jwt-kit"),
                .product(name: "Bcrypt", package: "swift-bcrypt"),
                .product(name: "SystemModule", package: "feather-system-module"),
                .product(name: "FeatherValidationFoundation", package: "feather-validation"),
                .target(name: "UserModuleDatabaseKit"),
            ]
        ),

        .target(
            name: "UserModuleMigrationKit",
            dependencies: [
                .product(name: "Bcrypt", package: "swift-bcrypt"),
                .product(name: "SystemModuleMigrationKit", package: "feather-system-module"),
                .target(name: "UserModuleDatabaseKit"),
            ]
        ),

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
                .product(name: "FeatherPushDriverMemory", package: "feather-push-driver-memory"),
                .product(name: "FeatherDatabaseDriverSQLite", package: "feather-database-driver-sqlite"),
                .product(name: "JWTKit", package: "jwt-kit"),
            ]
        ),
    ]
)
