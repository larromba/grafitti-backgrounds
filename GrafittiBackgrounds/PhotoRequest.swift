import Foundation

struct PhotoRequest: Request {
    let url: URL
    let httpVerb: HTTPVerb = .GET

    init(resource: PhotoResource) {
        url = resource.url
    }
}
