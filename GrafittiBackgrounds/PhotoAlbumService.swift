//
//  PhotoAlbumService.swift
//  GrafittiBackgrounds
//
//  Created by Lee Arromba on 02/12/2017.
//  Copyright © 2017 Pink Chicken. All rights reserved.
//

import Cocoa

protocol PhotoAlbumServiceInterface {
    var networkManager: NetworkManagerInterface { get }

    func getPhotoAlbums(success: @escaping (([PhotoAlbum]) -> ()), failure: ((Error) -> ())?)
    func getPhotoResources(_ album: PhotoAlbum, success: @escaping (([PhotoResource]) -> ()), failure: ((Error) -> ())?)
    func cancelAll()
}

class PhotoAlbumService: PhotoAlbumServiceInterface {
    let networkManager: NetworkManagerInterface

    init(networkManager: NetworkManagerInterface) {
        self.networkManager = networkManager
    }

    func getPhotoAlbums(success: @escaping (([PhotoAlbum]) -> ()), failure: ((Error) -> ())?) {
        let request = PhotoAlbumsRequest(url: API.photoAlbums.url)
        networkManager.send(request: request, success: { [unowned self] response in
            guard let response = response as? PhotoAlbumsResponse else {
                assertionFailure("expected PhotoAlbumsResponse")
                return
            }
            var albums = response.photoAlbums
            let group = DispatchGroup()
            for (index, album) in albums.enumerated() {
                group.enter()
                self.getPhotoResources(album, success: { resources in
                    albums[index].resources = resources
                    group.leave()
                }, failure: { error in
                    group.leave()
                })
            }
            group.notify(queue: DispatchQueue.global()) {
                success(albums)
            }
        }, failure: { error in
            failure?(error)
        })
    }

    func getPhotoResources(_ album: PhotoAlbum, success: @escaping (([PhotoResource]) -> ()), failure: ((Error) -> ())?) {
        let request = PhotoResourceRequest(url: album.url)
        networkManager.send(request: request, success: { response in
            guard let response = response as? PhotoResourceResponse else {
                assertionFailure("expected PhotoResourceResponse")
                return
            }
            success(response.photoResources)
        }, failure: { error in
            failure?(error)
        })
    }

    func cancelAll() {
        networkManager.cancelAll()
    }
}
