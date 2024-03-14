//
//  File.swift
//
//
//  Created by Tibor Bodecs on 20/02/2024.
//

import CoreModuleInterface

public protocol UserProfileInterface {

    func get() async throws -> User.Account.Detail
}
