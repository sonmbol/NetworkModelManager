//
//  URLRequest+JSON.swift
//  NetworkManager
//
//  Created by ahmed suliman on 19/07/2022.
//

import Foundation
import struct Alamofire.HTTPHeaders

public enum NetworkMethod {
    case get
    case post
}

extension NetworkMethod: CustomStringConvertible {
    public var description: String {
        switch self {
        case .get:               return "GET"
        case .post:              return "POST"
        }
    }
}

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

public enum UploadType: String {
    case avatar
    case file
}

extension URLRequest {
    static func prepareRequest<T: RequestData>(req: T) -> URLRequest? {
        guard let url = req.baseUrl else {
            return nil
        }

        var components = URLComponents()
        components.scheme = url.scheme
        components.host = url.host
        components.path = req.endPoint ?? ""

        if req.query == .path,
           case .queryItem(let queryItems) = req.parameters {
            components.queryItems = queryItems
        }


        var request = URLRequest(url: components.url!)
        request.httpMethod = req.method.description

        if req.query == .json {

            switch req.parameters {
            case .dict(let dict):
                request.httpBody = try? JSONSerialization.data(withJSONObject: dict, options: [])
            case .queryItem(let queryItems):
                components.queryItems = queryItems
                request.httpBody = components.percentEncodedQuery?.data(using: .utf8)
            case .object(let objc):
                request.httpBody = try? JSONEncoder().encode(objc)
            }
        }
        request.headers = req.headers

        return request
    }

}

