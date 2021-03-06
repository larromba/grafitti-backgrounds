import Foundation
import Networking

enum TestResource: String {
    case photoAlbumResponseReal = "photoAlbumResponse_real.js"
    case photoAlbumResponse1Album = "photoAlbumResponse_1album.js"

    case photoResponseReal = "photoResponse_real.html"
    case photoResponse0Photo = "photoResponse_0photo.html"
    case photoResponse1Photo = "photoResponse_1photo.html"

    case photoResourceResponseReal = "photoResourceResponse_real.html"
    case photoResourceResponse1Photo = "photoResourceResponse_1photo.html"

    var file: FileResource {
        class Dummy {}
        return FileResource(name: rawValue, bundle: Bundle(for: Dummy.self))
    }
}
