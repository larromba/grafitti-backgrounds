@testable import Grafitti_Backgrounds
import XCTest

class ResponseTests: XCTestCase {
	func testPhotoResponse() {
        XCTAssertNoThrow(try PhotoResponse(data: Resource.photo.load()))
	}

	func testPhotoAlbumsResponse() {
        XCTAssertNoThrow(try PhotoAlbumsResponse(data: Resource.photoAlbum.load()))
	}

	func testPhotoResourceResponse() {
        XCTAssertNoThrow(try PhotoResourceResponse(data: Resource.photoResource.load()))
	}
}
