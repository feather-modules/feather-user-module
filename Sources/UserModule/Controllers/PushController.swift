//
//  File.swift
//
//
//  Created by Tibor Bodecs on 04/02/2024.
//

import FeatherComponent
import FeatherModuleKit
import Foundation
import Logging
import NanoID
import SystemModuleKit
import UserModuleKit
import FeatherPush

struct PushController: UserPushInterface {
    
    let components: ComponentRegistry
    let user: UserModuleInterface

    public init(
        components: ComponentRegistry,
        user: UserModuleInterface
    ) {
        self.components = components
        self.user = user
    }

    // MARK: -

    public func create(
        _ input: User.Push.Create
    ) async throws -> User.Push.Detail {
        
        /*let rdb = try await components.relationalDatabase()
        let db = try await rdb.database()
        
        // check for push tokens
        if let recipients = input.recipients, !recipients.isEmpty {
            let tokensBuilder = User.PushToken.Query(db: db)
            let tokenList = try await tokensBuilder.all(filter: .init(
                field: .token,
                operator: .in,
                value: recipients
            ))
            
        // send for everybody
        } else {
            
            
        }
        
        let pushMessage = PushMessage(
            title: input.title,
            body: input.message
        )*/
        fatalError()
    }
    
    func get(
        id: ID<User.Push>
    ) async throws -> User.Push.Detail? {
        return try await getDetail(id)
    }
    
    func list(_ input: User.Push.List.Query) async throws -> User.Push.List {
       
        /*let queryBuilder = try await getQueryBuilder()

        var field: User.Push.Model.FieldKeys
        switch input.sort.by {
        case .title:
            field = .title
        case .message:
            field = .message
        }
        
        let filterGroup = input.search.flatMap { value in
            QueryFilterGroup<User.Push.Model.CodingKeys>(
                relation: .or,
                fields: [
                    .init(
                        field: .title,
                        operator: .like,
                        value: "%\(value)%"
                    ),
                    .init(
                        field: .message,
                        operator: .like,
                        value: "%\(value)%"
                    )
                ]
            )
        }
        
        let result = try await queryBuilder.list(
            .init(
                page: .init(
                    size: input.page.size,
                    index: input.page
                        .index
                ),
                orders: [
                    .init(
                        field: field,
                        direction: input.sort.order.queryDirection
                    )
                ],
                filter: filterGroup.map { .init(groups: [$0]) }
            )
        )

        return try User.Push.List(
            items: result.items.map {
                try $0.toListItem()
            },
            count: UInt(result.total)
        )*/
        fatalError()
    }

    private func getQueryBuilder() async throws -> User.Push.Query {
        /*let rdb = try await components.relationalDatabase()
        let db = try await rdb.database()
        return .init(db: db)*/
        fatalError()
    }

    private func getDetail(_ id: ID<User.Push>) async throws
        -> User.Push.Detail
    {
        /*let queryBuilder = try await getQueryBuilder()
        guard let model = try await queryBuilder.get(id) else {
            throw User.Error.unknown
        }
        return User.Push.Detail(
            id: model.id.toID(),
            title: model.title,
            message: model.message,
            topic: User.Push.Topic(rawValue: model.topic)!,
            date: model.date
        )*/
        fatalError()
    }

}
