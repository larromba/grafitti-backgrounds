import Foundation
@testable import Grafitti_Backgrounds

enum Resource: String {
    private class Dummy {}

    case photoAlbum = "photoAlbum.js"
    case photo = "photo.html"
    case photoResource = "photoResource.html"

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
