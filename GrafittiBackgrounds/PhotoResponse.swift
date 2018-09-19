//
//  PhotoResponse.swift
//  GrafittiBackgrounds
//
//  Created by Lee Arromba on 03/12/2017.
//  Copyright © 2017 Pink Chicken. All rights reserved.
//

import Cocoa

class PhotoResponse: Response {
    enum ResponseError: Error {
        case badHTML
        case missingImageURL
        case badImageURL
    }

    let data: Data
    let imageURL: URL

    init(data: Data) throws {
        self.data = data
        guard let html = String(data: data, encoding: .utf8) else {
            throw ResponseError.badHTML
        }
        let regex = try NSRegularExpression(pattern: "data-url=\\\"[\\w:\\/.-]+\\\"", options: [])
        let matches = regex.matches(in: html, options: .init(rawValue: 0), range: NSRange(location: 0, length: html.count))
        guard let result = matches.first, let range = Range(result.range, in: html) else {
            throw ResponseError.missingImageURL
        }
        let urlString = String(html[range]).appending("=w2148-h1610-no").replacingOccurrences(of: "data-url=", with: "").replacingOccurrences(of: "\"", with: "")
        guard let url = URL(string: urlString) else {
            throw ResponseError.badImageURL
        }
        self.imageURL = url
    }

	/// testing
	init(imageURL: URL) {
		data = Data()
		self.imageURL = imageURL
	}
}
