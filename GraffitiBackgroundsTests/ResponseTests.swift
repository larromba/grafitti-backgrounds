@testable import Graffiti_Backgrounds
import XCTest

final class ResponseTests: XCTestCase {
    func testPhotoResponse() {
        XCTAssertNoThrow(try PhotoResponse(data: TestResource.photoResponseReal.load()))
    }

    func testPhotoAlbumsResponse() {
        XCTAssertNoThrow(try PhotoAlbumsResponse(data: TestResource.photoAlbumResponseReal.load()))
    }

    func testPhotoResourceResponse() {
        XCTAssertNoThrow(try PhotoResourceResponse(data: TestResource.photoResourceResponseReal.load()))
    }
}
