//
//  NetworkModel.swift
//  NetworkModel
//
//  Created by ahmed suliman on 17/10/2023.
//

import Foundation
import class Alamofire.Session
import struct Alamofire.DataTask
import enum Alamofire.AFError

protocol NetworkModelProtocol {
    associatedtype Request: RequestRoute
    associatedtype Response: Decodable

    static func request(request: Request) async -> Swift.Result<Response, AFError>
}

extension NetworkModelProtocol {
    @inlinable
    public static func request(request: Request) async -> Swift.Result<Response, AFError> {
        guard let request = URLRequest.prepareRequest(requestRoute: request) else {
            return .failure(AFError.invalidURL(url: request.url))
        }

        let session = Session.prepareSession(host: request.url?.host ?? "")
        let task: DataTask<Response> = session.request(request).serializingDecodable(Response.self)

        guard let httpResponse = await task.response.response,
              case let httpStatus = HTTPStatusCode.ResponseType(code: httpResponse.statusCode),
              httpStatus.pass else {

            if let httpResponse = await task.response.response {
                return .failure(.sessionInvalidated(error: HTTPStatusCode.ResponseType(code: httpResponse.statusCode)))
            }

            return .failure(.sessionInvalidated(error: HTTPStatusCode.ResponseType.undefined))
        }

        return await task.result
    }

}

