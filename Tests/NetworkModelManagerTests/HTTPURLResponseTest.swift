//
//  HTTPURLResponseTest.swift
//  
//
//  Created by ahmed suliman on 07/03/2024.
//

import XCTest
@testable import NetworkManager

final class HTTPURLResponseTest: XCTestCase {

    func testStatusCodeResponseIsInformational() throws {
        let status = HTTPStatusCode.ResponseType(code: 100)
        XCTAssertEqual(status, .informational(.continue))
        XCTAssertEqual(status.pass, false)
        XCTAssertNotEqual(status, .success(.ok))
        XCTAssertNotEqual(status, .informational(.processing))
        let nilStatus = HTTPStatusCode.ResponseType(code: 190)
        XCTAssertNotEqual(nilStatus, .informational(.continue))
    }

    func testStatusCodeResponseIsSuccess() throws {
        let status = HTTPStatusCode.ResponseType(code: 200)
        XCTAssertEqual(status, .success(.ok))
        XCTAssertEqual(status.pass, true)
        XCTAssertNotEqual(status, .success(.accepted))
        XCTAssertNotEqual(status, .informational(.processing))
        let nilStatus = HTTPStatusCode.ResponseType(code: 290)
        XCTAssertNotEqual(nilStatus, .success(.ok))
    }

    func testStatusCodeResponseIsRedirection() throws {
        let status = HTTPStatusCode.ResponseType(code: 300)
        XCTAssertEqual(status, .redirection(.multipleChoices))
        XCTAssertEqual(status.pass, true)
        XCTAssertNotEqual(status, .success(.accepted))
        XCTAssertNotEqual(status, .informational(.processing))
        let nilStatus = HTTPStatusCode.ResponseType(code: 390)
        XCTAssertNotEqual(nilStatus, .redirection(.multipleChoices))
    }

    func testStatusCodeResponseIsClientError() throws {
        let status = HTTPStatusCode.ResponseType(code: 400)
        XCTAssertEqual(status, .clientError(.badRequest))
        XCTAssertEqual(status.pass, true)
        XCTAssertNotEqual(status, .success(.accepted))
        XCTAssertNotEqual(status, .informational(.processing))
        let nilStatus = HTTPStatusCode.ResponseType(code: 490)
        XCTAssertNotEqual(nilStatus, .clientError(.badRequest))
    }

    func testStatusCodeResponseIsServerErrorError() throws {
        let status = HTTPStatusCode.ResponseType(code: 500)
        XCTAssertEqual(status, .serverError(.internalServerError))
        XCTAssertEqual(status.pass, false)
        XCTAssertNotEqual(status, .success(.accepted))
        XCTAssertNotEqual(status, .informational(.processing))
        let nilStatus = HTTPStatusCode.ResponseType(code: 590)
        XCTAssertNotEqual(nilStatus, .serverError(.internalServerError))
    }

    func testStatusCodeResponseIsUndefined() throws {
        let status = HTTPStatusCode.ResponseType(code: 500000)
        XCTAssertEqual(status, .undefined)
    }
}
