//
//  NetworkManager.swift
//  NetworkManager
//
//  Created by ahmed suliman on 17/10/2023.
//

import Foundation
import class Alamofire.Session
import class Alamofire.ServerTrustManager
import class Alamofire.DisabledTrustEvaluator
import struct Alamofire.HTTPHeaders
import enum Alamofire.AFError
import AlamofireNetworkActivityLogger

public enum RequestParameter {
    case dict([String: Any])
    case queryItem([URLQueryItem])
    case object(Codable)
}

public enum RequestQuery {
    case path
    case json
}

public protocol RequestData {
    associatedtype ResponseType: Decodable

    var baseUrl: URL? { get }
    var endPoint: String? { get }
    var headers: HTTPHeaders { get }
    var method: NetworkMethod { get }
    var query: RequestQuery { get }
    var parameters: RequestParameter { get }
}

public protocol NetworkManagerProtocol {
    func request<T: RequestData>(req: T) async -> Swift.Result<T.ResponseType, Error>
}

public class NetworkManager: NetworkManagerProtocol {

    public static let shared: NetworkManagerProtocol = NetworkManager()

    private init() {
    #if DEBUG
        NetworkActivityLogger.shared.level = .debug
        NetworkActivityLogger.shared.startLogging()
    #endif
    }

    private func session(host: String) -> Session {
        let manager = ServerTrustManager(evaluators: [host: DisabledTrustEvaluator()])
        let configuration = URLSessionConfiguration.af.default
        return Session(configuration: configuration, serverTrustManager: manager)
    }

    public func request<T: RequestData>(req: T) async -> Swift.Result<T.ResponseType, Error> {
        guard let request = URLRequest.prepareRequest(req: req) else {
            return .failure(NetworkError.invalidURL)
        }

        let session = session(host: req.baseUrl?.host ?? "")
        let task = session.request(request).serializingDecodable(T.ResponseType.self)

        guard let httpResponse = await task.response.response,
              case let httpStatus = HTTPStatusCode.ResponseType(code: httpResponse.statusCode),
              httpStatus.pass else {

            if let httpResponse = await task.response.response {
                return .failure(HTTPStatusCode.ResponseType(code: httpResponse.statusCode))
            }

            return .failure(HTTPStatusCode.ResponseType.undefined)
        }

        switch await task.result {
        case .success(let data):
            return .success(data)

        case .failure(let error):
            return .failure(error)
        }

    }
}
