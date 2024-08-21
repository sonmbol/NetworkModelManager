//
//  URLRequest+Helper.swift
//  NetworkManager
//
//  Created by ahmed suliman on 19/07/2022.
//

import Foundation
import class Alamofire.Session
import class Alamofire.ServerTrustManager
import class Alamofire.DisabledTrustEvaluator
import struct Alamofire.HTTPHeaders

public enum HTTPHeaderField: String {
    case authentication  = "Authorization"
    case contentType     = "Content-Type"
    case acceptType      = "Accept"
    case acceptEncoding  = "Accept-Encoding"
    case acceptLangauge  = "Accept-Language"
}

public enum ContentType: String {
    case json            = "application/json"
    case urlencoded      = "application/x-www-form-urlencoded"
    case multipart       = "multipart/form-data"
    case ENUS            = "en-us"
}


// MARK: - URLRequest
extension URLRequest {
    @inlinable
    static func prepareRequest<T: RequestRoute>(requestRoute: T) -> URLRequest? {
        guard let url = try? requestRoute.url.asURL() else {
            return nil
        }

        var components = URLComponents()
        components.scheme = url.scheme
        components.host = requestRoute.url.host
        components.path = requestRoute.url.path

        if requestRoute.query == .path,
           case .queryItem(let queryItems) = requestRoute.parameters {
            components.queryItems = queryItems
        }


        var request = URLRequest(url: url)
        request.httpMethod = requestRoute.method.description

        if requestRoute.query == .json {

            switch requestRoute.parameters {
            case .dict(let dict):
                request.httpBody = try? JSONSerialization.data(withJSONObject: dict, options: [])
            case .queryItem(let queryItems):
                components.queryItems = queryItems
                request.httpBody = components.percentEncodedQuery?.data(using: .utf8)
            case .object(let objc):
                request.httpBody = try? JSONEncoder().encode(objc)
            }
        }
        request.headers = requestRoute.headers

        return request
    }

}


extension Session {
    @inlinable
    static func prepareSession(host: String) -> Session {
        let manager = ServerTrustManager(evaluators: [host: DisabledTrustEvaluator()])
        let configuration = URLSessionConfiguration.af.default
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        return Session(configuration: configuration, serverTrustManager: manager)
    }
}
