import Foundation
import NetworkManager

struct PhotoAlbumsRequest: Request {
    let url: URL = API.photoAlbums.url
    let httpVerb: HTTPVerb = .GET
}
