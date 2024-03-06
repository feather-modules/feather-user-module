//
//  File.swift
//
//
//  Created by Tibor Bodecs on 20/02/2024.
//

import CoreSDKInterface

public protocol UserAccountMeInterface {

    func getMyAccount() async throws -> UserAccountDetail
}
