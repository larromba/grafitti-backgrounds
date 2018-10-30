import Foundation

struct PhotoAlbumsRequest: Request {
    let url: URL = API.photoAlbums.url
    let httpVerb: HTTPVerb = .GET
}
