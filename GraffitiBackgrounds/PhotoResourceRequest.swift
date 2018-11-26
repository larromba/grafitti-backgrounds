import Foundation
import Networking

struct PhotoResourceRequest: Request {
    let url: URL
    let httpVerb: HTTPVerb = .GET

    init(album: PhotoAlbum) {
        self.url = album.url
    }
}
