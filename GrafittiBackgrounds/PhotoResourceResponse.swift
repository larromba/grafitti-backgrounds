//
//  PhotoResourceResponse.swift
//  GrafittiBackgrounds
//
//  Created by Lee Arromba on 02/12/2017.
//  Copyright © 2017 Pink Chicken. All rights reserved.
//

import Foundation

struct PhotoResourceResponse: Response {
    enum ResponseError: Error {
        case badHTML
        case missingBaseURL
        case badBaseURL
        case missingPhotoURLs
    }

    let data: Data
    let photoResources: [PhotoResource]

    init(data: Data) throws {
        self.data = data
        guard let html = String(data: data, encoding: .utf8) else {
            throw ResponseError.badHTML
        }
        var regex = try NSRegularExpression(pattern: "https://photos.google.com/share/[\\w-?=]+", options: [])
        var matches = regex.matches(in: html, options: .init(rawValue: 0), range: NSRange(location: 0, length: html.count))
        guard let baseURLResult = matches.first, let baseURLRange = Range(baseURLResult.range, in: html) else {
            throw ResponseError.missingBaseURL
        }
        let baseURLString = String(html[baseURLRange])
        guard let baseURL = URL(string: baseURLString), let baseURLComponenets = URLComponents(url: baseURL, resolvingAgainstBaseURL: false) else {
            throw ResponseError.badBaseURL
        }

        regex = try NSRegularExpression(pattern: "AF_initDataCallback\\([\\s\\w:',(){\\[\"\\/.\\]}-]+", options: [])
        matches = regex.matches(in: html, options: .init(rawValue: 0), range: NSRange(location: 0, length: html.count))
        guard let photoURLBlockResult = matches.first, let photoURLBlockRange = Range(photoURLBlockResult.range, in: html) else {
            throw ResponseError.missingPhotoURLs
        }
        let photoURLBlock = String(html[photoURLBlockRange])

        regex = try NSRegularExpression(pattern: "\\\"[\\w-]+\\\",\\s*\\[\\\"https:", options: [])
        matches = regex.matches(in: photoURLBlock, options: .init(rawValue: 0), range: NSRange(location: 0, length: photoURLBlock.count))
        photoResources = try matches.flatMap({ result -> PhotoResource? in
            guard let range = Range(result.range, in: photoURLBlock) else {
                log("error getting dirty urlComponent")
                return nil
            }
            let dirtyURLComponent = String(photoURLBlock[range])

            regex = try NSRegularExpression(pattern: "\\\"[\\w-]+\\\"", options: [])
            guard let urlComponentResult = regex.matches(in: dirtyURLComponent, options: .init(rawValue: 0), range: NSRange(location: 0, length: dirtyURLComponent.count)).first, let urlComponentRange = Range(urlComponentResult.range, in: dirtyURLComponent) else {
                log("error getting urlComponent")
                return nil
            }
            let urlComponent = String(dirtyURLComponent[urlComponentRange]).replacingOccurrences(of: "\"", with: "")
            var components = baseURLComponenets
            components.path = components.path.appending("/photo/").appending(urlComponent)
            guard let url = components.url else {
                log("error with url")
                return nil
            }
            return PhotoResource(url: url, fileURL: nil)
        })
    }
}
