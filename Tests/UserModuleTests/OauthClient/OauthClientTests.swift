//
//  File.swift
//
//  Created by gerp83 on 25/08/2024
//

import FeatherModuleKit
import UserModule
import UserModuleKit
import XCTest

final class OauthClientTests: TestCase {

    func testCreate() async throws {
        let input = User.OauthClient.Create(
            name: "name",
            type: .app,
            redirectUri: "redirectUri",
            issuer: "issuer",
            subject: "subject",
            audience: "audience"
        )
        let detail = try await module.oauthClient.create(input)
        XCTAssertEqual(detail.name, input.name)
        XCTAssertEqual(detail.type, input.type)
        XCTAssertEqual(detail.redirectUri, input.redirectUri)
        XCTAssertEqual(detail.issuer, input.issuer)
        XCTAssertEqual(detail.subject, input.subject)
        XCTAssertEqual(detail.audience, input.audience)
    }

    func testDetail() async throws {
        let input = User.OauthClient.Create(
            name: "name",
            type: .app,
            redirectUri: "redirectUri",
            issuer: "issuer",
            subject: "subject",
            audience: "audience"
        )
        let detail = try await module.oauthClient.create(input)
        let savedDetail = try await module.oauthClient.require(detail.id)
        XCTAssertEqual(detail.name, savedDetail.name)
        XCTAssertEqual(detail.type, savedDetail.type)
        XCTAssertEqual(detail.redirectUri, savedDetail.redirectUri)
        XCTAssertEqual(detail.issuer, savedDetail.issuer)
        XCTAssertEqual(detail.subject, savedDetail.subject)
        XCTAssertEqual(detail.audience, savedDetail.audience)
    }

    func testList() async throws {
        let input = User.OauthClient.Create(
            name: "name",
            type: .app,
            redirectUri: "redirectUri",
            issuer: "issuer",
            subject: "subject",
            audience: "audience"
        )

        let input2 = User.OauthClient.Create(
            name: "name2",
            type: .app,
            redirectUri: "redirectUri",
            issuer: "issuer",
            subject: "subject",
            audience: "audience"
        )

        let _ = try await module.oauthClient.create(input)
        let _ = try await module.oauthClient.create(input2)
        let list = try await module.oauthClient.list(
            User.OauthClient.List.Query(
                search: nil,
                sort: .init(by: .name, order: .asc),
                page: .init()
            )
        )
        XCTAssertTrue(list.count == 2)
    }

    func testPatch() async throws {
        let input = User.OauthClient.Create(
            name: "name",
            type: .app,
            redirectUri: "redirectUri",
            issuer: "issuer",
            subject: "subject",
            audience: "audience"
        )
        let detail = try await module.oauthClient.create(input)

        let patchedDetail = try await module.oauthClient.patch(
            detail.id,
            .init(name: "newName")
        )
        XCTAssertEqual(patchedDetail.name, "newName")
    }

    func testUpdate() async throws {
        let input = User.OauthClient.Create(
            name: "name",
            type: User.OauthClient.ClientType.app,
            redirectUri: "redirectUri",
            issuer: "issuer",
            subject: "subject",
            audience: "audience"
        )
        let detail = try await module.oauthClient.create(input)

        let updateDetail = try await module.oauthClient.update(
            detail.id,
            .init(
                name: "newName",
                type: .api,
                redirectUri: "newRedirectUri",
                issuer: "newIssuer",
                subject: "newSubject",
                audience: "newAudience"
            )
        )
        XCTAssertEqual(updateDetail.name, "newName")
        XCTAssertEqual(updateDetail.type, .api)
        XCTAssertEqual(updateDetail.redirectUri, "newRedirectUri")
        XCTAssertEqual(updateDetail.issuer, "newIssuer")
        XCTAssertEqual(updateDetail.subject, "newSubject")
        XCTAssertEqual(updateDetail.audience, "newAudience")
    }

}
