//
//  PhotoService.swift
//  GrafittiBackgrounds
//
//  Created by Lee Arromba on 02/12/2017.
//  Copyright © 2017 Pink Chicken. All rights reserved.
//

import Cocoa

// sourcery: name = PhotoService
protocol PhotoServicing: Mockable {
    var networkManager: NetworkManaging { get }
    var fileManager: FileManaging { get }
    var saveURL: URL { get }

    func downloadPhoto(_ resource: PhotoResource, success: @escaping ((PhotoResource) -> ()), failure: ((Error) -> ())?)
    func cancelAll()
}

final class PhotoService: PhotoServicing {
    enum PhotoError: Error {
        case badSaveLocation
    }

    let networkManager: NetworkManaging
    let fileManager: FileManaging
    let saveURL: URL

	init(networkManager: NetworkManaging, fileManager: FileManaging, saveURL: URL) {
        self.networkManager = networkManager
        self.fileManager = fileManager
		self.saveURL = saveURL
        if !fileManager.fileExists(atPath: saveURL.absoluteString) {
            do {
                try self.fileManager.createDirectory(at: saveURL, withIntermediateDirectories: true, attributes: nil)
            } catch {
                assertionFailure(error.localizedDescription)
            }
        }
    }

    func downloadPhoto(_ resource: PhotoResource, success: @escaping ((PhotoResource) -> ()), failure: ((Error) -> ())?) {
        let request = PhotoRequest(url: resource.url)
        networkManager.send(request: request, success: { [unowned self] response in
            guard let response = response as? PhotoResponse else {
                assertionFailure("expected PhotoResponse")
                return
            }
            self.networkManager.download(response.imageURL, success: { [unowned self] url in
                let filePath = self.saveURL.appendingPathComponent(url.lastPathComponent).absoluteString.replacingOccurrences(of: ".tmp", with: ".png")
                guard let fileURL = URL(string: filePath) else {
                    failure?(PhotoError.badSaveLocation)
                    return
                }
                do {
                    try self.fileManager.moveItem(at: url, to: fileURL)
                    var resource = resource
                    resource.fileURL = fileURL
                    success(resource)
                } catch {
                    failure?(error)
                }
            }, failure: { error in
                failure?(error)
            })
        }, failure: { error in
            failure?(error)
        })
    }

    func cancelAll() {
        networkManager.cancelAll()
    }
}
