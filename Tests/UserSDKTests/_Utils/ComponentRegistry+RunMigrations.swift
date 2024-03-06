//
//  File.swift
//
//
//  Created by Tibor Bodecs on 16/02/2024.
//

import DatabaseMigrationKit
import FeatherComponent
import MigrationKit
import SystemSDKMigration
import UserSDKMigration

extension ComponentRegistry {

    func runMigrations() async throws {

        let migrator = Migrator(
            components: self,
            storage: MigrationEntryStorageEphemeral()
        )

        try await migrator.perform(
            groups: [
                SystemMigrationGroup(),
                UserMigrationGroup(),
            ]
        )
    }
}
