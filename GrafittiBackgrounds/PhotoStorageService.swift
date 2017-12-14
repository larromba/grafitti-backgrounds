//
//  PhotoStorageService.swift
//  GrafittiBackgrounds
//
//  Created by Lee Arromba on 03/12/2017.
//  Copyright © 2017 Pink Chicken. All rights reserved.
//

import Foundation

protocol PhotoStorageServiceInterface {
    var dataManager: DataManagerInterface { get }
    var fileManager: FileManagerInterface { get }

    func save(_ resources: [PhotoResource])
    func load() -> [PhotoResource]?
    func remove(_ resources: [PhotoResource])
}

class PhotoStorageService: PhotoStorageServiceInterface {
    private enum Key: String {
        case photoResource
    }
    private let encoder = PropertyListEncoder()
    private let decoder = PropertyListDecoder()

    let dataManager: DataManagerInterface
    let fileManager: FileManagerInterface

    init(dataManager: DataManagerInterface, fileManager: FileManagerInterface) {
        self.dataManager = dataManager
        self.fileManager = fileManager
    }

    func save(_ resources: [PhotoResource]) {
        do {
            let data = try encoder.encode(resources)
            dataManager.save(data, key: Key.photoResource.rawValue)
        } catch {
            log(error.localizedDescription)
        }
    }

    func load() -> [PhotoResource]? {
        guard let data = dataManager.load(key: Key.photoResource.rawValue) else {
            return nil
        }
        return try? decoder.decode(Array<PhotoResource>.self, from: data)
    }

    func remove(_ resources: [PhotoResource]) {
        resources.forEach { resource in
            do {
                guard let fileURL = resource.fileURL else {
                    return
                }
                try self.fileManager.removeItem(at: fileURL)
            } catch {
                log(error.localizedDescription)
            }
        }
        dataManager.save(nil, key: Key.photoResource.rawValue)
    }
}
