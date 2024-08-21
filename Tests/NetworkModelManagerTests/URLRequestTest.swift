//
//  URLRequestTest.swift
//
//
//  Created by ahmed suliman on 07/03/2024.
//

import XCTest
@testable import NetworkManager
import Alamofire

extension RequestURL {
    init(path: String) {
        self.init(host: "https:\\www.google.com", path: path)
    }
}

extension RequestRoute {
    var headers: HTTPHeaders { [] }

    var method: NetworkMethod { .get }

    var query: RequestQuery { .path }

}

enum DataRequestGetPathMock: NetworkModelProtocol {
    struct Request: RequestRoute {
        var url: RequestURL { RequestURL(path: "") }
        var headers: HTTPHeaders {
            [
                HTTPHeaderField.acceptType.rawValue: ContentType.json.rawValue,
                HTTPHeaderField.contentType.rawValue: ContentType.urlencoded.rawValue
            ]
        }
        var parameters: RequestParameter { .dict([:]) }
    }

    struct Response: Codable {
        let id: Int?

        init(id: Int? = nil) {
            self.id = id
        }
    }
}

struct DataResponseMock: Codable {
    let id: Int?

    init(id: Int? = nil) {
        self.id = id
    }
}

enum DataRequestGetJsonMock: NetworkModelProtocol {

    struct Request: RequestRoute {
        var url: RequestURL { RequestURL(path: "") }
        var headers: HTTPHeaders {
            [
                HTTPHeaderField.acceptType.rawValue: ContentType.json.rawValue,
                HTTPHeaderField.contentType.rawValue: ContentType.urlencoded.rawValue
            ]
        }

        var method: NetworkMethod { .get }

        var query: RequestQuery { .json }

        var parameters: RequestParameter { .dict([:]) }
    }

    typealias Response = DataResponseMock
}


enum DataRequestPostMock: NetworkModelProtocol {

    struct Request: RequestRoute {
        var url: RequestURL { RequestURL(path: "") }
        var method: NetworkMethod { .post }
        var parameters: RequestParameter { .dict([:]) }
    }
    typealias Response = DataResponseMock
}

enum DataRequestPostObjMock: NetworkModelProtocol {

    struct Request: RequestRoute {
        var url: RequestURL { RequestURL(path: "") }
        var method: NetworkMethod { .post }
        var parameters: RequestParameter { .object(DataResponseMock()) }
    }
    typealias Response = DataResponseMock

}

enum DataRequestPostDicMock: NetworkModelProtocol {
    struct Request: RequestRoute {
        var url: RequestURL { RequestURL(path: "") }
        var method: NetworkMethod { .post }
        var parameters: RequestParameter { .dict(["st": "1"]) }
    }

    typealias Response = DataResponseMock

}

enum DataRequestNilMock: NetworkModelProtocol {

    struct Request: RequestRoute {
        var url: RequestURL { RequestURL(host: "", path: "") }
        var method: NetworkMethod { .post }
        var parameters: RequestParameter { .object(DataResponseMock()) }
    }

    typealias Response = DataResponseMock
}

final class URLRequestTest: XCTestCase {

    func testGetWithPathMethod() throws {
        let request = URLRequest.prepareRequest(requestRoute: DataRequestGetPathMock.Request())
        XCTAssertNotNil(request)
    }

    func testPostMethod() throws {
        let request = URLRequest.prepareRequest(requestRoute: DataRequestPostMock.Request())
        XCTAssertNotNil(request)
    }

    func testPostWithObjcMethod() throws {
        let request = URLRequest.prepareRequest(requestRoute: DataRequestPostObjMock.Request())
        XCTAssertNotNil(request)
    }

    func testPostWithDictMethod() async throws {
        let request = URLRequest.prepareRequest(requestRoute: DataRequestPostDicMock.Request())
        XCTAssertNotNil(request)
    }

}
