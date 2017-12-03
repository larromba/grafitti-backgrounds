 //
//  AppCoordinator.swift
//  GooglePhotosBackground
//
//  Created by Lee Arromba on 02/12/2017.
//  Copyright © 2017 Pink Chicken. All rights reserved.
//

import Cocoa

class AppCoordinator {
    private let photoAlbumService = PhotoAlbumService()
    private let photoService = PhotoService()
    private let photoStorageService = PhotoStorageService()
    private var downloadedResources = [PhotoResource]()
    private var timer: Timer?
    private var fileManager = FileManager.default
    private var isDownloadInProgress = false

    init() {
        downloadedResources = photoStorageService.load() ?? []
    }

    func start() {
        timer = Timer.scheduledTimer(timeInterval: 60 * 60 * 24 * 5, target: self, selector: #selector(timerTick(_:)), userInfo: nil, repeats: true)
        timerTick(timer!)
    }

    // MARK: - private

    @objc private func timerTick(_ sender: Timer) {
        guard !isDownloadInProgress else {
            return
        }
        photoStorageService.remove(downloadedResources)
        populatePicturesFolder(numberOfPhotos: 50)
    }

    private func populatePicturesFolder(numberOfPhotos: Int) {
        isDownloadInProgress = true

        photoAlbumService.getPhotoAlbums(success: { [unowned self] albums in
            let allResources = albums.map({ $0.resources }).reduce([], +)
            let group = DispatchGroup()
            for _ in 0..<numberOfPhotos {
                group.enter()
                let resource = allResources[Int(arc4random_uniform(UInt32(allResources.count)))]
                self.photoService.downloadPhoto(resource, success: { [unowned self] resource in
                    self.downloadedResources.append(resource)
                    group.leave()
                }, failure: { error in
                    log(error.localizedDescription)
                    group.leave()
                })
            }
            group.notify(queue: DispatchQueue.global()) {
                self.photoStorageService.save(self.downloadedResources)
                self.isDownloadInProgress = false
            }
        }, failure: { error in
            log(error.localizedDescription)
        })
    }
}
