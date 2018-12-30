import Foundation

extension URL {
    static var mock = URL(string: "http://www.google.com")!

    static func makePhotoFolderURL() -> URL {
        return URL(fileURLWithPath: "\(NSTemporaryDirectory())\(UUID().uuidString)")
    }

    static func makeTemporaryFolderURL() -> URL {
        let url = URL(fileURLWithPath: "\(NSTemporaryDirectory())\(UUID().uuidString)")
        do {
            try FileManager.default.createDirectory(at: url, withIntermediateDirectories: false, attributes: nil)
        } catch {
            assertionFailure(error.localizedDescription)
        }
        return url
    }
}
