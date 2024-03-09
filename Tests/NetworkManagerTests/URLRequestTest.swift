//
//  URLRequestTest.swift
//
//
//  Created by ahmed suliman on 07/03/2024.
//

import XCTest
@testable import NetworkManager
import Alamofire

struct DataResponseMock: Codable {
    let id: Int?

    init(id: Int? = nil) {
        self.id = id
    }
}

extension RequestData {
    var baseUrl: URL? { URL(string: "https:\\www.google.com") }
    var endPoint: String? { "" }
    var headers: HTTPHeaders {
        [
            HTTPHeaderField.acceptType.rawValue: ContentType.json.rawValue,
            HTTPHeaderField.contentType.rawValue: ContentType.urlencoded.rawValue
        ]
    }

    var method: NetworkMethod { .get }

    var query: RequestQuery { .path }
}
struct DataRequestGetMock: RequestData {

    typealias ResponseType = DataResponseMock

    var query: RequestQuery { .json }
    var parameters: RequestParameter { .queryItem(queryItem) }

    private var queryItem: [URLQueryItem] {
        [
            .init(name: "st", value: "st"),
            .init(name: "user_id", value: "userId")
        ]
    }

}

struct DataRequestGetPathMock: RequestData {

    typealias ResponseType = DataResponseMock

    var endPoint: String? { nil }
    var method: NetworkMethod { .get }

    var parameters: RequestParameter { .queryItem(queryItem) }

    private var queryItem: [URLQueryItem] {
        [
            .init(name: "st", value: "st"),
            .init(name: "user_id", value: "userId")
        ]
    }

}

struct DataRequestPostMock: RequestData {

    typealias ResponseType = DataResponseMock


    var method: NetworkMethod { .post }

    var query: RequestQuery { .json }
    var parameters: RequestParameter { .queryItem(queryItem) }

    private var queryItem: [URLQueryItem] {
        [
            .init(name: "st", value: "st"),
            .init(name: "user_id", value: "userId")
        ]
    }

}

struct DataRequestPostObjMock: RequestData {

    typealias ResponseType = DataResponseMock


    var method: NetworkMethod { .post }

    var query: RequestQuery { .json }
    var parameters: RequestParameter { .object(DataResponseMock()) }

}

struct DataRequestPostDicMock: RequestData {

    typealias ResponseType = DataResponseMock


    var method: NetworkMethod { .post }

    var query: RequestQuery { .json }
    var parameters: RequestParameter { .dict(["st": "1"]) }

}

struct DataRequestNilMock: RequestData {

    typealias ResponseType = DataResponseMock

    var baseUrl: URL? { nil }

    var parameters: RequestParameter { .object(DataResponseMock()) }

}

final class URLRequestTest: XCTestCase {

    func testGetMethod() throws {
        let request = URLRequest.prepareRequest(req: DataRequestGetMock())
        XCTAssertNotNil(request)
    }

    func testGetWithPathMethod() throws {
        let request = URLRequest.prepareRequest(req: DataRequestGetPathMock())
        XCTAssertNotNil(request)
    }

    func testPostMethod() throws {
        let request = URLRequest.prepareRequest(req: DataRequestPostMock())
        XCTAssertNotNil(request)
    }

    func testPostWithObjcMethod() throws {
        let request = URLRequest.prepareRequest(req: DataRequestPostObjMock())
        XCTAssertNotNil(request)
    }

    func testPostWithDictMethod() async throws {
        let request = URLRequest.prepareRequest(req: DataRequestPostDicMock())
        XCTAssertNotNil(request)
    }

    func testNilRequest() async throws {
        let request = URLRequest.prepareRequest(req: DataRequestNilMock())
        XCTAssertNil(request)
    }
}
