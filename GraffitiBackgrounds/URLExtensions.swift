import Foundation

extension URL {
    static var defaultSaveLocation: URL {
        guard let path = NSSearchPathForDirectoriesInDomains(.picturesDirectory, .userDomainMask, true).first else {
            assertionFailure("shouldn't be nil")
            return URL(string: "file://")!
        }
        let url = URL(fileURLWithPath: path).appendingPathComponent(Bundle.appName)
        return url
    }

    static var help: URL {
        return URL(string: "http://github.com/larromba/graffiti-backgrounds")!
    }
}
