import XCTest
@testable import NetworkManager

final class NetworkModelTests: XCTestCase {

    func testGetWithPathMethod() async throws {
        let requestModel = DataRequestGetPathMock.Request()
        let request =  await DataRequestGetPathMock.request(request: requestModel)
        XCTAssertNotNil(request)
    }

    func testPostMethod() async throws {
        let requestModel = DataRequestPostMock.Request()
        let request =  await DataRequestPostMock.request(request: requestModel)
        XCTAssertNotNil(request)
    }

    func testPostWithObjcMethod() async throws {
        let requestModel = DataRequestPostObjMock.Request()
        let request =  await DataRequestPostObjMock.request(request: requestModel)
        XCTAssertNotNil(request)
    }

    func testPostWithDictMethod() async throws {
        let requestModel = DataRequestPostDicMock.Request()
        let request =  await DataRequestPostDicMock.request(request: requestModel)
        XCTAssertNotNil(request)
    }

}
