@testable import Graffiti_Backgrounds
import XCTest

final class ResponseTests: XCTestCase {
    func testPhotoResponse() {
        XCTAssertNoThrow(try PhotoResponse(data: TestResource.photoResponseReal.file.load()))
    }

    func testPhotoAlbumsResponse() {
        XCTAssertNoThrow(try PhotoAlbumsResponse(data: TestResource.photoAlbumResponseReal.file.load()))
    }

    func testPhotoResourceResponse() {
        XCTAssertNoThrow(try PhotoResourceResponse(data: TestResource.photoResourceResponseReal.file.load()))
    }
}
