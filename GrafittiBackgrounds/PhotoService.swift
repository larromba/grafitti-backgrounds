//
//  PhotoService.swift
//  GrafittiBackgrounds
//
//  Created by Lee Arromba on 02/12/2017.
//  Copyright © 2017 Pink Chicken. All rights reserved.
//

import Cocoa

protocol PhotoServiceInterface {
    var networkManager: NetworkManagerInterface { get }
    var fileManager: FileManagerInterface { get }
    var saveURL: URL { get }

    func downloadPhoto(_ resource: PhotoResource, success: @escaping ((PhotoResource) -> ()), failure: ((Error) -> ())?)
    func cancelAll()
}

class PhotoService: PhotoServiceInterface {
    enum PhotoError: Error {
        case badSaveLocation
    }

    let networkManager: NetworkManagerInterface
    let fileManager: FileManagerInterface
    let saveURL: URL

    init(networkManager: NetworkManagerInterface, fileManager: FileManagerInterface) {
        self.networkManager = networkManager
        self.fileManager = fileManager
        guard let path = NSSearchPathForDirectoriesInDomains(.picturesDirectory, .userDomainMask, true).first else {
            fatalError("shouldn't be nil")
        }
        saveURL = URL(fileURLWithPath: path).appendingPathComponent("GrafittiBackgrounds")

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
