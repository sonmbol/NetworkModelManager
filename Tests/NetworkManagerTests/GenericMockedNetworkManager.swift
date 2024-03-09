//
//  GenericMockedNetworkManager.swift
//
//
//  Created by ahmed suliman on 09/03/2024.
//

import Foundation
@testable import NetworkManager

final class MockedURLProtocol: URLProtocol {

    // 1. Handler to test the request and return mock response.
    static var loadingHandler: ((URLRequest) throws -> (HTTPURLResponse, Data?))?

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        guard let handler = MockedURLProtocol.loadingHandler else {
            fatalError("Handler not set.")
        }

        do {
            // 2. Call handler with received request and capture the tuple of response and data.
            let (response, data) = try handler(request)

            // 3. Send received response to the client.
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)

            if let data = data {
              // 4. Send received data to the client.
              client?.urlProtocol(self, didLoad: data)
            }

            // 5. Notify request has been finished.
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            // 6. Notify received error.
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    override func stopLoading() {}
}


// MARK: - Repository Mock Example
enum MockResponseError: Error {
    case jsonNotFound
    case dataNotFound
    case dataIsNotInFormat
}

public class GenericMockedNetworkManager: NetworkManagerProtocol {

    let session: URLSession = {
        let configuration: URLSessionConfiguration = {
            let configuration = URLSessionConfiguration.default
            configuration.protocolClasses = [MockedURLProtocol.self]

            return configuration
        }()

        return URLSession(configuration: configuration)
    }()

    /// Please override mockedModule to you're current Bundle module
    public var mockedModule: Bundle {
        Bundle.module
    }

    public func request<T: RequestData>(req: T) async -> Swift.Result<T.ResponseType, Error> {
        let resource = String(describing: T.ResponseType.self)
        guard let url = mockedModule.url(forResource: resource, withExtension: "json") else {
            return .failure(MockResponseError.jsonNotFound)
        }
        
        let mockedData = try? Data(contentsOf: url)

        let mockedURL = MockedURLProtocol()

        MockedURLProtocol.loadingHandler = { request in
            let response = HTTPURLResponse(
                url: req.baseUrl ?? (URL(string: "")!),
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, mockedData)
        }

        guard let result = try? await session.data(for: mockedURL.request) else {
            return .failure(MockResponseError.dataNotFound)
        }

        guard let data = try? JSONDecoder().decode(T.ResponseType.self, from: result.0) else {
            return .failure(MockResponseError.dataIsNotInFormat)
        }

        return .success(data)

    }
}

