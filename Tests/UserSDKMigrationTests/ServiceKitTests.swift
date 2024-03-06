import FeatherComponent
import FeatherRelationalDatabase
import FeatherRelationalDatabaseDriverSQLite
import Logging
import NIO
import SQLKit
import UserSDKInterface
import UserMigrationKit
import XCTest

@testable import UserSDK

final class ServiceKitTests: XCTestCase {

    func testExample() async throws {
        let eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        let threadPool = NIOThreadPool(numberOfThreads: 1)
        threadPool.start()

        let components = ComponentRegistry()
        try await components.addRelationalDatabase(
            SQLiteRelationalDatabaseComponentContext(
                eventLoopGroup: eventLoopGroup,
                connectionSource: .init(
                    configuration: .init(
                        storage: .memory,
                        enableForeignKeys: true
                    ),
                    threadPool: threadPool
                )
            )
        )

        try await components.run()

        //        setenv("FEATHER_SERVICE_MIGRATOR_LOG_LEVEL", "trace", 1)

        let migration = Migration()
        let migrator = FeatherComponentMigrator(
            components: components,
            storage: FeatherComponentMigrationEntryStorageEphemeral(),
            logger: .env("test-migrator", logLevel: .trace)
        )
        try await migrator.perform(
            groups: migration.groups()
        )

        do {
            let db = try await components.relationalDatabase().connection()

            try await runQueryTests(db)

            try await runSystemAccessTokenModelTest(db)
            try await runSystemPermissionModelTest(db)
            try await runSystemPushMessageModelTest(db)

            try await runUserAccountModelTest(db)
            try await runUserAccountPasswordResetModelTest(db)
            try await runUserAccountRoleModelTest(db)
            try await runUserInvitationModelTest(db)
            try await runUserPushTokenModelTest(db)
            try await runUserRoleModelTest(db)
            try await runUserRolePermissionModelTest(db)
            try await runUserTokenModelTest(db)

        }
        catch {
            print("-------------------------------")
            print("\(error)")
            print("-------------------------------")
        }

        try await components.shutdown()
        try await eventLoopGroup.shutdownGracefully()
    }

    func runQueryTests(_ db: SQLDatabase) async throws {

    }
}
