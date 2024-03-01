//
//  File.swift
//
//
//  Created by Tibor Bodecs on 20/02/2024.
//

import CoreInterfaceKit

public protocol UserAccountMeInterface {

    func getMyAccount() async throws -> User.Account.Detail
}
