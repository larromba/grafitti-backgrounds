import Foundation

enum API {
    case photoAlbums

    var url: URL {
        switch self {
        case .photoAlbums:
            return URL(string: "http://larhythmix.com/js/preload.js")!
        }
    }
}
