 //
//  AppCoordinator.swift
//  GrafittiBackgrounds
//
//  Created by Lee Arromba on 02/12/2017.
//  Copyright © 2017 Pink Chicken. All rights reserved.
//

import Cocoa

class AppCoordinator {
    private let preferencesCoordinator = PreferencesCoordinator()
    private let photoAlbumService = PhotoAlbumService()
    private let photoService = PhotoService()
    private let photoStorageService = PhotoStorageService()
    private var reloadTimer: Timer?
    private var fileManager = FileManager.default
    private var isDownloadInProgress = false {
        didSet {
            guard let refreshItem = self.statusItem.item.menu?.item(at: 0) as? MenuItem else { return }
            if self.isDownloadInProgress {
                refreshItem.actionBlock = { [unowned self] in
                    self.cancelReload()
                }
                refreshItem.title = "Cancel Refresh".localized
            } else {
                refreshItem.actionBlock = { [unowned self] in
                    self.reloadPhotos()
                }
                refreshItem.title = "Refresh Folder".localized
            }
            self.statusItem.item.menu?.item(at: 2)?.isEnabled = !self.isDownloadInProgress
            self.statusItem.isLoading = self.isDownloadInProgress
        }
    }
    private let statusItem = StatusItem(config:
        StatusItem.Config(image: #imageLiteral(resourceName: "spray-can"), loadingImage: #imageLiteral(resourceName: "download"), spinnerColor: NSColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.8))
    )
    private let workspace = NSWorkspace.shared
    private let app = NSApp

    init() {
        statusItem.item.menu = Menu(title: "", items: [
            MenuItem(title: "Refresh Folder".localized, actionBlock: { [unowned self] in
                self.reloadPhotos()
            }),
            MenuItem(title: "Open Folder".localized, actionBlock: { [unowned self] in
                self.workspace.open(self.photoService.saveURL)
            }),
            MenuItem(title: "Clear Folder".localized, actionBlock: { [unowned self] in
                self.cleanFolder()
            }),
            NSMenuItem.separator(),
            MenuItem(title: "Preferences".localized, actionBlock: { [unowned self] in
                self.preferencesCoordinator.open()
            }),
            MenuItem(title: "System Preferences".localized, actionBlock: { [unowned self] in
                self.workspace.open(URL(fileURLWithPath: "/System/Library/PreferencePanes/DesktopScreenEffectsPref.prefPane"))
            }),
            NSMenuItem.separator(),
            MenuItem(title: "About".localized, actionBlock: { [unowned self] in
                self.app?.orderFrontStandardAboutPanel(self)
            }),
            MenuItem(title: "Quit".localized, actionBlock: { [unowned self] in
                self.app?.terminate(self)
            })
        ])
    }

    deinit {
        stopTimer()
        photoService.cancelAll()
        photoAlbumService.cancelAll()
    }

    func start() {
        preferencesCoordinator.delegate = self
        load(preferencesCoordinator.preferences)
    }

    // MARK: - private

    private func load(_ preferences: Preferences) {
        stopTimer()
        if preferences.isAutoRefreshEnabled {
            startTimer(with: preferences.autoRefreshTimeIntervalSeconds)
        }
    }

    private func startTimer(with timeInterval: TimeInterval) {
        reloadTimer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true, block: { [unowned self] timer in
            self.reloadPhotos()
        })
        reloadPhotos()
    }

    private func stopTimer() {
        reloadTimer?.invalidate()
        reloadTimer = nil
    }

    private func reloadPhotos() {
        guard !isDownloadInProgress else {
            return
        }
        cleanFolder()
        populatePicturesFolder(numberOfPhotos: preferencesCoordinator.preferences.numberOfPhotos)
    }

    private func cancelReload() {
        photoService.cancelAll()
        photoAlbumService.cancelAll()
        isDownloadInProgress = false
    }

    private func cleanFolder() {
        if let resources = self.photoStorageService.load() {
            photoStorageService.remove(resources)
        }
    }

    private func populatePicturesFolder(numberOfPhotos: Int) {
        isDownloadInProgress = true

        photoAlbumService.getPhotoAlbums(success: { [unowned self] albums in
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
                        self.statusItem.loadingPercentage = Double(i) / Double(numberOfPhotos)
                    }
                    group.leave()
                }, failure: { [unowned self] error in
                    log(error.localizedDescription)
                    DispatchQueue.main.async {
                        self.statusItem.loadingPercentage = Double(i) / Double(numberOfPhotos)
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

 // MARK: - PreferencesCoordinatorDelegate

extension AppCoordinator: PreferencesCoordinatorDelegate {
    func preferencesCoordinator(_ coordinator: PreferencesCoordinator, didUpdatePreferences preferences: Preferences) {
        load(preferences)
    }
}
