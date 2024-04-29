//
//  File.swift
//
//
//  Created by Tibor Bodecs on 04/02/2024.
//

import FeatherComponent
import FeatherModuleKit
import FeatherPush
import Foundation
import Logging
import NanoID
import SystemModuleKit
import UserModuleKit

struct PushController: UserPushInterface,
    ControllerList,
    ControllerGet
{

    typealias Query = User.Push.Query
    typealias List = User.Push.List
    typealias Detail = User.Push.Detail

    let components: ComponentRegistry
    let user: UserModuleInterface

    public init(
        components: ComponentRegistry,
        user: UserModuleInterface
    ) {
        self.components = components
        self.user = user
    }

    static let listFilterColumns: [Model.ColumnNames] =
        [
            .title, .message,
        ]

    // MARK: -

    public func create(
        _ input: User.Push.Create
    ) async throws -> User.Push.Detail {

        let db = try await components.database().connection()
        var recipients: [Recipient] = []

        // check for tokens
        if let inputRecipients = input.recipients, !inputRecipients.isEmpty {
            let tokenList = try await User.PushToken.Query.listAll(
                filter: .init(
                    column: .token,
                    operator: .in,
                    value: inputRecipients
                ),
                on: db
            )
            recipients = tokenList.toPushRecipient()

            // or send for everybody
        }
        else {
            let tokenList = try await User.PushToken.Query.listAll(on: db)
            recipients = tokenList.toPushRecipient()
        }

        let notification = Notification(title: input.title, body: input.message)
        try await components.push()
            .send(
                notification: notification,
                to: recipients
            )
        let newModel = User.Push.Model(
            id: NanoID.generateKey(),
            title: notification.title,
            message: notification.body,
            topic: User.Push.Topic.message.rawValue,
            date: Date()
        )
        try await User.Push.Query.insert(newModel, on: db)
        return .init(
            id: newModel.id.toID(),
            title: newModel.title,
            message: newModel.message,
            topic: .message,
            date: newModel.date
        )
    }

}
