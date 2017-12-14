//
//  PhotoCoordinator.swift
//  GrafittiBackgrounds
//
//  Created by Lee Arromba on 05/12/2017.
//  Copyright © 2017 Pink Chicken. All rights reserved.
//

import Foundation

protocol PhotoCoordinatorDelegate: class {
    func photoCoordinator(_ photoCoordinator: PhotoCoordinator, updatedDownloadPercentage percentage: Double)
    func photoCoordinator(_ photoCoordinator: PhotoCoordinator, didChangeDownloadState inProgress: Bool)
}

protocol PhotoCoordinatorInterface {
    var photoAlbumService: PhotoAlbumServiceInterface { get }
    var photoService: PhotoServiceInterface { get }
    var photoStorageService: PhotoStorageServiceInterface { get }
    var isDownloadInProgress: Bool { get set }
    var preferences: Preferences { get set }
    var folderURL: URL { get }
    var delegate: PhotoCoordinatorDelegate? { get set }

    func reloadPhotos()
    func cancelReload()
    func cleanFolder()
}

class PhotoCoordinator: PhotoCoordinatorInterface {
    let photoAlbumService: PhotoAlbumServiceInterface
    let photoService: PhotoServiceInterface
    let photoStorageService: PhotoStorageServiceInterface
    var isDownloadInProgress = false {
        didSet {
            delegate?.photoCoordinator(self, didChangeDownloadState: isDownloadInProgress)
        }
    }
    var preferences = Preferences() {
        didSet {
            setupTimer()
        }
    }
    var folderURL: URL {
        return photoService.saveURL
    }
    weak var delegate: PhotoCoordinatorDelegate?

    private var reloadTimer: Timer?

    init(photoAlbumService: PhotoAlbumServiceInterface, photoService: PhotoServiceInterface, photoStorageService: PhotoStorageServiceInterface) {
        self.photoAlbumService = photoAlbumService
        self.photoService = photoService
        self.photoStorageService = photoStorageService
        setupTimer()
    }

    deinit {
        stopTimer()
        photoService.cancelAll()
        photoAlbumService.cancelAll()
    }

    func reloadPhotos() {
        guard !isDownloadInProgress else {
            return
        }
        setupTimer()
        cleanFolder()
        populatePicturesFolder(numberOfPhotos: preferences.numberOfPhotos)
    }

    func cancelReload() {
        photoService.cancelAll()
        photoAlbumService.cancelAll()
        isDownloadInProgress = false
    }

    func cleanFolder() {
        if let resources = self.photoStorageService.load() {
            photoStorageService.remove(resources)
        }
    }

    // MARK: - private

    private func setupTimer() {
        stopTimer()
        if preferences.isAutoRefreshEnabled {
            startTimer(with: preferences.autoRefreshTimeIntervalSeconds)
        }
    }

    private func startTimer(with timeInterval: TimeInterval) {
        reloadTimer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true, block: { [unowned self] timer in
            self.reloadPhotos()
        })
    }

    private func stopTimer() {
        reloadTimer?.invalidate()
        reloadTimer = nil
    }

    private func populatePicturesFolder(numberOfPhotos: Int) {
        isDownloadInProgress = true

        photoAlbumService.getPhotoAlbums(success: { [unowned self] albums in
            guard self.isDownloadInProgress else { return }

            let allResources = albums.map({ $0.resources }).reduce([], +)
            let group = DispatchGroup()
            for i in 0..<numberOfPhotos {
                group.enter()
                let resource = allResources[Int(arc4random_uniform(UInt32(allResources.count)))]
                self.photoService.downloadPhoto(resource, success: { [unowned self] resource in
                    DispatchQueue.main.async {
                        var resources = self.photoStorageService.load() ?? []
                        resources.append(resource)
                        self.photoStorageService.save(resources)
                        self.delegate?.photoCoordinator(self, updatedDownloadPercentage: Double(i) / Double(numberOfPhotos))
                    }
                    group.leave()
                }, failure: { [unowned self] error in
                    log(error.localizedDescription)
                    DispatchQueue.main.async {
                        self.delegate?.photoCoordinator(self, updatedDownloadPercentage: Double(i) / Double(numberOfPhotos))
                    }
                    group.leave()
                })
            }
            group.notify(queue: .main) {
                self.isDownloadInProgress = false
            }
        }, failure: { error in
            log(error.localizedDescription)
        })
    }
}
