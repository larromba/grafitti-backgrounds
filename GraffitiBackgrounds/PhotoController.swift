import AsyncAwait
import Foundation
import Log
import Result

protocol PhotoControllerDelegate: AnyObject, Mockable {
    func photoControllerTimerTriggered(_ photoController: PhotoController)
    func photoController(_ photoController: PhotoController, updatedDownloadPercentage percentage: Double)
    func photoController(_ photoController: PhotoController, didChangeDownloadState inProgress: Bool)
}

// sourcery: name = PhotoController
protocol PhotoControllable: Mockable {
    var isDownloadInProgress: Bool { get }
    var photoFolderURL: URL { get }

    func setPreferences(_ preferences: Preferences)
    func reloadPhotos() -> Async<[PhotoResource]>
    func cancelReload()
    func clearFolder() -> Result<Void>
    func setDelegate(_ delegate: PhotoControllerDelegate)
}

final class PhotoController: PhotoControllable {
    private let photoAlbumService: PhotoAlbumServicing
    private let photoService: PhotoServicing
    private let photoStorageService: PhotoStorageServicing
    private var preferences: Preferences
    private var reloadTimer: Timer?
    private weak var delegate: PhotoControllerDelegate?

    private(set) var isDownloadInProgress = false {
        didSet { delegate?.photoController(self, didChangeDownloadState: isDownloadInProgress) }
    }
    let photoFolderURL: URL

    init(photoAlbumService: PhotoAlbumServicing,
         photoService: PhotoServicing,
         photoStorageService: PhotoStorageServicing,
         preferences: Preferences = Preferences(),
         photoFolderURL: URL) {
        self.photoAlbumService = photoAlbumService
        self.photoService = photoService
        self.photoStorageService = photoStorageService
        self.preferences = preferences
        self.photoFolderURL = photoFolderURL
        setupTimer()
    }

    deinit {
        stopTimer()
        photoService.cancelAll()
        photoAlbumService.cancelAll()
    }

    // swiftlint:disable function_body_length
    func reloadPhotos() -> Async<[PhotoResource]> {
        return Async { completion in
            async({
                guard !self.isDownloadInProgress else {
                    return onMain { completion(.failure(PhotoError.downloadInProgress)) }
                }
                onMain { self.startReloading() }
                let numberOfPhotos = self.preferences.numberOfPhotos

                log("1. get all albums")
                let albums = try await(self.photoAlbumService.fetchPhotoAlbums(progress: { percentage in
                    onMain {
                        let normalized = Progress.normalize(progress: percentage, forStepIndex: 0, inTotalSteps: 2)
                        self.delegate?.photoController(self, updatedDownloadPercentage: normalized)
                    }
                }))

                log("2. ensure there are enough photos to download within the albums")
                let numOfPossibleDownloads = albums.reduce(0, { $0 + $1.resources.count })
                guard numOfPossibleDownloads >= numberOfPhotos else {
                    return onMain { completion(.failure(PhotoError.notEnoughImagesAvailable)) }
                }

                log("3. choose some random photos from the albums to download")
                var resources = albums.map { $0.resources }.reduce([], +)
                resources = (0..<numberOfPhotos).map { _ in
                    resources[Int(arc4random_uniform(UInt32(resources.count)))]
                }

                log("4. download \(resources.count) photos")
                let downloaded = try await(self.photoService.downloadPhotos(resources, progress: { percentage in
                    onMain {
                        let normalized = Progress.normalize(progress: percentage, forStepIndex: 1, inTotalSteps: 2)
                        self.delegate?.photoController(self, updatedDownloadPercentage: normalized)
                    }
                }))

                log("5. ensure enough photos were downloaded (\(downloaded.count) / \(numberOfPhotos)")
                guard downloaded.count >= numberOfPhotos else {
                    return onMain { completion(.failure(PhotoError.notEnoughImagesDownloaded)) }
                }

                log("6. clear previous photos, move new photos, save resource information")
                let result = self.clearFolder()
                    .flatMap {
                        self.photoService.movePhotos(downloaded, toFolder: self.photoFolderURL)
                    }.flatMap { resources -> Result<[PhotoResource]> in
                        switch self.photoStorageService.save(resources) {
                        case .success:
                            return .success(resources)
                        case .failure(let error):
                            return .failure(error)
                        }
                    }

                log("7. finish up")
                onMain {
                    self.stopReloading()
                    completion(result)
                }
            }, onError: { error in
                onMain {
                    self.stopReloading()
                    completion(.failure(error))
                }
            })
        }
    }

    func cancelReload() {
        photoService.cancelAll()
        photoAlbumService.cancelAll()
        isDownloadInProgress = false
    }

    func clearFolder() -> Result<Void> {
        return photoStorageService.load()
            .flatMap {
                self.photoStorageService.remove($0)
            }.flatMap { _ in
                return Result.success(())
            }
    }

    func setPreferences(_ preferences: Preferences) {
        self.preferences = preferences
        setupTimer()
    }

    func setDelegate(_ delegate: PhotoControllerDelegate) {
        self.delegate = delegate
    }

    // MARK: - private

    private func setupTimer() {
        stopTimer()
        guard preferences.isAutoRefreshEnabled else { return }
        startTimer(with: preferences.autoRefreshTimeIntervalSeconds)
    }

    private func startTimer(with timeInterval: TimeInterval) {
        reloadTimer = .scheduledTimer(
            withTimeInterval: timeInterval,
            repeats: true,
            block: { [weak self] _ in
                guard let `self` = self else { return }
                self.delegate?.photoControllerTimerTriggered(self)
            }
        )
    }

    private func stopTimer() {
        reloadTimer?.invalidate()
        reloadTimer = nil
    }

    private func startReloading() {
        setupTimer()
        isDownloadInProgress = true
    }

    private func stopReloading() {
        isDownloadInProgress = false
        delegate?.photoController(self, updatedDownloadPercentage: 0.0)
    }
}
