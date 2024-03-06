//
//  File.swift
//
//
//  Created by Tibor Bodecs on 13/02/2024.
//

import CoreSDKInterface
import DatabaseQueryKit
import Foundation

extension ListQuery {

    init<T: RawRepresentable>(
        input: List.Query<T>,
        queryBuilderType: any IdentifiedQueryBuilder.Type
    ) throws where T.RawValue == String {
        let filterConditions: [QueryFilter.QueryFilterCondition]
        let sort: [QuerySort]

        if let search = input.search, !search.isEmpty {
            filterConditions = [
                .init(
                    method: .equals,
                    key: queryBuilderType.idField.rawValue,
                    value: search
                )
            ]
        }
        else {
            filterConditions = []
        }

        if let s = input.sort {
            sort = [
                .init(
                    by: s.rawValue,
                    order: input.order == .asc ? .asc : .desc
                )
            ]
        }
        else {
            sort = []
        }

        self.init(
            page: .init(
                size: input.page.size,
                index: input.page.index
            ),
            filter: .init(conditions: filterConditions),
            sort: sort
        )
    }

}

extension ListQuery.RDBResult {

    func toResult<I, S>(input: List.Query<S>, _ transform: (T) -> I)
        -> List.Result<I, S>
    {
        .init(
            items: data.map(transform),
            count: count,
            query: input
        )
    }

}
