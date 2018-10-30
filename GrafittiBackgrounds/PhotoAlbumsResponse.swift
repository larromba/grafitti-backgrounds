import Foundation

enum PhotoAlbumsResponseError: Error {
	case malformedHTML
	case noPhotoAlbumsFound
}

struct PhotoAlbumsResponse: Response {
	typealias ErrorType = PhotoAlbumsResponseError

    let data: Data
    let photoAlbums: [PhotoAlbum]

    init(data: Data) throws {
        self.data = data
        guard let html = String(data: data, encoding: .utf8) else {
            throw PhotoAlbumsResponseError.malformedHTML
        }
        let regex = try NSRegularExpression(
            pattern: "https://photos.app.goo.gl/[a-zA-Z0-9]+|https://goo.gl/photos/[a-zA-Z0-9]+",
            options: []
        )
        let matches = regex.matches(
            in: html,
            options: .init(rawValue: 0),
            range: NSRange(location: 0, length: html.count)
        )
        guard !matches.isEmpty else {
            throw PhotoAlbumsResponseError.noPhotoAlbumsFound
        }
        photoAlbums = matches.compactMap { result -> PhotoAlbum? in
            guard let range = Range(result.range, in: html), let url = URL(string: String(html[range])) else {
                log("can't create photo album url")
                return nil
            }
            return PhotoAlbum(url: url, resources: [])
        }
    }
}
