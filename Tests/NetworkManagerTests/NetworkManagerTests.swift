import XCTest
@testable import NetworkManager

final class NetworkManagerTests: XCTestCase {

    private var manager: NetworkManagerProtocol!

    override func setUp() {
        manager = GenericMockedNetworkManager()
        super.setUp()
    }

    override func tearDown() {
        manager = nil
        super.tearDown()
    }

    func testMockResponse() async throws {
        let result = await manager.request(req: DataRequestGetMock())
        if case .success(let data) = result {
            XCTAssertEqual(data.id, 1)
        }

    }

    func testGetMethod() async throws {
        let request =  await NetworkManager.shared.request(req: DataRequestGetMock())
        XCTAssertNotNil(request)
    }

    func testGetWithPathMethod() async throws {
        let request =  await NetworkManager.shared.request(req: DataRequestGetPathMock())
        XCTAssertNotNil(request)
    }

    func testPostMethod() async throws {
        let request =  await NetworkManager.shared.request(req: DataRequestPostMock())
        XCTAssertNotNil(request)
    }

    func testPostWithObjcMethod() async throws {
        let request =  await NetworkManager.shared.request(req: DataRequestPostObjMock())
        XCTAssertNotNil(request)
    }

    func testPostWithDictMethod() async throws {
        let request =  await NetworkManager.shared.request(req: DataRequestPostDicMock())
        XCTAssertNotNil(request)
    }

}
