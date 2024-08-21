//
//  RequestRoute.swift
//
//
//  Created by ahmed suliman on 17/10/2023.
//

import Foundation
import protocol Alamofire.URLConvertible
import struct Alamofire.HTTPHeaders

// MARK: - Request URL
public protocol RequestURLProtocol: URLConvertible {
    var host: String { get }
    var path: String { get }
}

extension RequestURLProtocol {
    public func asURL() throws -> URL {
        guard let url = URL(string: host + path) else {
            fatalError("URL isn't valid")
        }
        return url
    }
}

@frozen
public struct RequestURL: RequestURLProtocol {
    public let host: String
    public let path: String
}

// MARK: - Network Method
public enum NetworkMethod {
    case get
    case post
    case put
    case delete
}

extension NetworkMethod: CustomStringConvertible {
    public var description: String {
        switch self {
        case .get:                 return "GET"
        case .post:                return "POST"
        case .put:                 return "PUT"
        case .delete:              return "DELETE"
        }
    }
}

// MARK: - Request Query
public enum RequestQuery {
    case path
    case json
}

// MARK: - Request Parameter
public enum RequestParameter {
    case queryItem([URLQueryItem])
    case dict([String: Any])
    case object(Codable)
}

// MARK: - Request Route
public protocol RequestRoute {
    var url: RequestURL { get }
    var headers: HTTPHeaders { get }
    var method: NetworkMethod { get }
    var query: RequestQuery { get }
    var parameters: RequestParameter { get }
}
