//
//  File.swift
//
//
//  Created by Tibor Bodecs on 20/02/2024.
//

import FeatherModuleKit

public protocol UserProfileInterface {

    func get() async throws -> User.Account.Detail
}
