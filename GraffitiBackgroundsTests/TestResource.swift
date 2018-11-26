import Foundation
@testable import Graffiti_Backgrounds
import NetworkManager
import Log

enum TestResource: FileName {
    private class Dummy {}

    case photoAlbumResponseReal = "photoAlbumResponse_real.js"
    case photoAlbumResponse1Album = "photoAlbumResponse_1album.js"

    case photoResponseReal = "photoResponse_real.html"
    case photoResponse1Photo = "photoResponse_1photo.html"

    case photoResourceResponseReal = "photoResourceResponse_real.html"
    case photoResourceResponse1Photo = "photoResourceResponse_1photo.html"

    // TODO: refactor in networkmanager
    func load() -> Data {
        let components = rawValue.components(separatedBy: ".")
        guard let fileName = components.first, let fileExt = components.last else {
            log_error("invalid fileName: \(rawValue)")
            return Data()
        }
        guard let url = Bundle(for: Dummy.self).url(forResource: fileName, withExtension: fileExt) else {
            log_error("missing resource url")
            return Data()
        }
        guard let data = try? Data(contentsOf: url) else {
            log_error("missing resource data")
            return Data()
        }
        return data
    }
}
