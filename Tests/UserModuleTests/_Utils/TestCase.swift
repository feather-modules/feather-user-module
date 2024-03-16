//
//  File.swift
//
//
//  Created by Tibor Bodecs on 16/02/2024.
//

import CoreModuleKit
import FeatherComponent
import NIO
import SystemModule
import UserModule
import UserModuleKit
import UserModuleMigrationKit
import XCTest

class TestCase: XCTestCase {

    var eventLoopGroup: EventLoopGroup!
    var components: ComponentRegistry!
    var module: UserModuleInterface!

    override func setUp() async throws {
        self.eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        components = ComponentRegistry()

        let system = SystemModule(components: components)
        module = UserModule(system: system, components: components)

        try await components.configure(.singleton, eventLoopGroup)
        try await components.run()
        try await components.runMigrations()
    }

    override func tearDown() async throws {
        try await components.shutdown()
        try await self.eventLoopGroup.shutdownGracefully()
    }
}
