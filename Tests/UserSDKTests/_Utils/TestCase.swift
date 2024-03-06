//
//  File.swift
//
//
//  Created by Tibor Bodecs on 16/02/2024.
//

import CoreSDKInterface
import FeatherComponent
import NIO
import SystemKit
import UserSDKInterface
import UserSDK
import UserSDKMigration
import XCTest

class TestCase: XCTestCase {

    var eventLoopGroup: EventLoopGroup!
    var components: ComponentRegistry!
    var sdk: UserInterface!

    override func setUp() async throws {
        self.eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        components = ComponentRegistry()

        let system = SystemSDK(components: components)
        sdk = UserSDK(system: system, components: components)

        try await components.configure(.singleton, eventLoopGroup)
        try await components.run()
        try await components.runMigrations()
    }

    override func tearDown() async throws {
        try await components.shutdown()
        try await self.eventLoopGroup.shutdownGracefully()
    }

    func unauthorizedCheck(
        _ block: () async throws -> Void
    ) async throws {
        try await XCTAssertThrowsAsync(
            {
                try await block()
            },
            ACLError.self,
            { error in
                switch error {
                case .forbidden(_):
                    XCTFail("Should be an unauthorized state.")
                case .unauthorized(let state):
                    XCTAssertEqual(state, .any)
                }
            },
            "The call should fail with an access control error"
        )
    }

    func forbiddenCheck(
        _ expectedPermission: String,
        _ block: () async throws -> Void
    ) async throws {

        try await XCTAssertThrowsAsync(
            {
                try await block()
            },
            ACLError.self,
            { error in
                switch error {
                case .forbidden(let state):
                    XCTAssertEqual(state.kind, .permission)
                    XCTAssertEqual(state.key, expectedPermission)
                case .unauthorized(_):
                    XCTFail("Should be a forbidden state.")
                }
            },
            "The call should fail with an access control error"
        )
    }
}
