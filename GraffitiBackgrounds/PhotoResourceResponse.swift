import Foundation
import Log
import Networking

struct PhotoResourceResponse: Response {
    let data: Data
    let resources: [PhotoResource]

    // swiftlint:disable function_body_length
    init(data: Data) throws {
        self.data = data
        guard let html = String(data: data, encoding: .utf8) else {
            throw PhotoResourceResponseError.malformedHTML
        }

        // get base url: https://photos.google.com/share/#hash
        var regex = try NSRegularExpression(pattern: "https://photos.google.com/share/[\\w-?=]+", options: [])
        var matches = regex.matches(
            in: html,
            options: .init(rawValue: 0),
            range: NSRange(location: 0, length: html.count)
        )
        guard let baseURLResult = matches.first, let baseURLRange = Range(baseURLResult.range, in: html) else {
            throw PhotoResourceResponseError.missingBaseURL
        }
        let baseURLString = String(html[baseURLRange])
        guard
            let baseURL = URL(string: baseURLString),
            let baseURLComponenets = URLComponents(url: baseURL, resolvingAgainstBaseURL: false) else {
                throw PhotoResourceResponseError.malformedBaseURL
        }

        // get photo block with url components: AF_initDataCallback(#json)
        regex = try NSRegularExpression(pattern: "AF_initDataCallback\\([\\s\\w:',(){\\[\"\\/.\\]}-]+", options: [])
        matches = regex.matches(in: html, options: .init(rawValue: 0), range: NSRange(location: 0, length: html.count))
        guard
            let photoURLBlockResult = matches.first,
            let photoURLBlockRange = Range(photoURLBlockResult.range, in: html) else {
                throw PhotoResourceResponseError.missingPhotoURLs
        }
        let photoURLBlock = String(html[photoURLBlockRange])

        // scrape dirty url components into array
        regex = try NSRegularExpression(pattern: "\\\"[\\w-]+\\\",\\s*\\[\\\"https:", options: [])
        matches = regex.matches(
            in: photoURLBlock,
            options: .init(rawValue: 0),
            range: NSRange(location: 0, length: photoURLBlock.count)
        )
        resources = try matches.compactMap { result -> PhotoResource? in
            // get dirty url component: "\"AF1QipNny8uQfuLxogrp1MpXAIS3sn8m0HSyfszcXsLz\",[\"https:"
            guard let range = Range(result.range, in: photoURLBlock) else {
                log_error("couldn't get dirty urlComponent")
                return nil
            }
            let dirtyURLComponent = String(photoURLBlock[range])

            // get clean url component: AF1QipMrjwDHdnirr5fnnzPULMNEB5pY2HY22dzs6pEM
            regex = try NSRegularExpression(pattern: "\\\"[\\w-]+\\\"", options: [])
            let urlComponentResults = regex.matches(
                in: dirtyURLComponent,
                options: .init(rawValue: 0),
                range: NSRange(location: 0, length: dirtyURLComponent.count)
            )
            guard
                let urlComponentResult = urlComponentResults.first,
                let urlComponentRange = Range(urlComponentResult.range, in: dirtyURLComponent) else {
                    log_error("couldn't get clean urlComponent")
                    return nil
            }
            let urlComponent = String(dirtyURLComponent[urlComponentRange]).replacingOccurrences(of: "\"", with: "")

            // create full photo url by appending clean url component
            var components = baseURLComponenets
            components.path = components.path.appending("/photo/").appending(urlComponent)
            guard let url = components.url else {
                log_error("components missing url")
                return nil
            }
            return PhotoResource(url: url, downloadURL: nil, fileURL: nil)
        }
    }
}
