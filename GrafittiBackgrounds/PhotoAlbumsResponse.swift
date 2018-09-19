//
//  PhotoAlbumsResponse.swift
//  GrafittiBackgrounds
//
//  Created by Lee Arromba on 02/12/2017.
//  Copyright © 2017 Pink Chicken. All rights reserved.
//

import Foundation

struct PhotoAlbumsResponse: Response {
    enum ResponseError: Error {
        case badHTML
    }

    let data: Data
    let photoAlbums: [PhotoAlbum]

    init(data: Data) throws {
        self.data = data
        guard let html = String(data: data, encoding: .utf8) else {
            throw ResponseError.badHTML
        }
        let regex = try NSRegularExpression(pattern: "https://photos.app.goo.gl/[a-zA-Z0-9]+|https://goo.gl/photos/[a-zA-Z0-9]+", options: [])
        let matches = regex.matches(in: html, options: .init(rawValue: 0), range: NSRange(location: 0, length: html.count))
		photoAlbums = matches.compactMap({ result -> PhotoAlbum? in
            guard let range = Range(result.range, in: html), let url = URL(string: String(html[range])) else {
                log("error getting album url")
                return nil
            }
            return PhotoAlbum(url: url, resources: [])
        })
    }
}
