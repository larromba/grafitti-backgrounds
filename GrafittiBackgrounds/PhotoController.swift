import Foundation

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
    func reloadPhotos(completion: @escaping (Result<[PhotoResource]>) -> Void)
    // sourcery: returnValue = Result.success(())
    func cancelReload()
    func clearFolder() -> Result<Void>
    func setDelegate(_ delegate: PhotoControllerDelegate)
}

final class PhotoController: PhotoControllable {
    private class ReloadFlow: AsyncFlowContext {
        var callBacks = [() -> Void]()
        var finally: (() -> Void)?

        var numberOfPhotos: Int = 0
        var photoAlbumResults = [AnyResult<PhotoAlbum>]()
        var photoDownloadResults = [AnyResult<PhotoResource>]()
        var photoAlbums = [PhotoAlbum]()
        var resources = [PhotoResource]()
    }

    private let photoAlbumService: PhotoAlbumServicing
    private let photoService: PhotoServicing
    private let photoStorageService: PhotoStorageServicing
    private var preferences: Preferences
    private var reloadTimer: Timer?
    private weak var delegate: PhotoControllerDelegate?

    private(set) var isDownloadInProgress = false {
        didSet {
            delegate?.photoController(self, didChangeDownloadState: isDownloadInProgress)
        }
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

    // swiftlint:disable function_body_length cyclomatic_complexity
    func reloadPhotos(completion: @escaping (Result<[PhotoResource]>) -> Void) {
        guard !isDownloadInProgress else {
            completion(.failure(PhotoError.downloadInProgress))
            return
        }
        setupTimer()
        isDownloadInProgress = true

        let flow = ReloadFlow()
        flow.numberOfPhotos = preferences.numberOfPhotos

        // 1. fetch photo albums
        flow.add {
            self.photoAlbumService.fetchPhotoAlbums(progress: { percentage in
                DispatchQueue.main.async {
					let percentage = Progress.normalize(progress: percentage, forStepIndex: 0, inTotalSteps: 2)
                    self.delegate?.photoController(self, updatedDownloadPercentage: percentage)
                }
            }, completion: { result in
                switch result {
                case .success(let results):
                    flow.photoAlbumResults = results
                    flow.next()
                case .failure(let error):
                    completion(.failure(error))
                    flow.finished()
                }
            })
        }

        // 2. ensure there are enough photos in the available albums to download
        flow.add {
            let successfulResults = flow.photoAlbumResults.filter { $0.result.isSuccess }
            let numOfPossibleDownloads = successfulResults.reduce(0, { $0 + $1.item.resources.count })
            guard numOfPossibleDownloads >= self.preferences.numberOfPhotos else {
                completion(.failure(PhotoError.notEnoughImagesAvailable))
                flow.finished()
                return
            }
            flow.photoAlbums = successfulResults.map { $0.item }
            flow.next()
        }

        // 3. choose some random photos
        flow.add {
            let allPhotoResources = flow.photoAlbums.map { $0.resources }.reduce([], +)
            flow.resources = (0..<flow.numberOfPhotos).map { _ in
                allPhotoResources[Int(arc4random_uniform(UInt32(allPhotoResources.count)))]
            }
            flow.next()
        }

        // 4. download photos
        flow.add {
            self.photoService.downloadPhotos(flow.resources, progress: { percentage in
                DispatchQueue.main.async {
					let percentage = Progress.normalize(progress: percentage, forStepIndex: 1, inTotalSteps: 2)
                    self.delegate?.photoController(self, updatedDownloadPercentage: percentage)
                }
            }, completion: { result in
                switch result {
                case .success(let results):
                    flow.photoDownloadResults = results
                    flow.next()
                case .failure(let error):
                    completion(.failure(error))
                    flow.finished()
                }
            })
        }

        // 5. ensure enough photos were downloaded
        flow.add {
            flow.resources = flow.photoDownloadResults
                .filter { $0.result.isSuccess }
                .map { return $0.item }
            guard flow.resources.count >= flow.numberOfPhotos else {
                completion(.failure(PhotoError.notEnoughImagesDownloaded))
                flow.finished()
                return
            }
            flow.next()
        }

        // 6. clear previous photos, try moving new photos, save resource information
        flow.add {
            let result = self.clearFolder().flatMap { _ -> Result<[PhotoResource]> in
                let result = self.photoService.movePhotos(flow.resources, toFolder: self.photoFolderURL)
                let failedResults = result.filter { $0.result.isFailure }
                if failedResults.isEmpty {
                    return .success(result.compactMap { $0.item })
                } else if failedResults.count == result.count {
                    return .failure(failedResults[0].result.error!)
                } else {
					// edge case
                    return .failure(PhotoError.someImagesMissingAfterMove)
                }
            }.flatMap { resources -> Result<[PhotoResource]> in
                switch self.photoStorageService.save(resources) {
                case .success:
                    return .success(resources)
                case .failure(let error):
                    return .failure(error)
                }
            }
            completion(result)
            flow.finished()
        }

        // 7. finish up
        flow.setFinally {
            DispatchQueue.main.async {
                self.isDownloadInProgress = false
                self.delegate?.photoController(self, updatedDownloadPercentage: 0.0)
            }
        }

        flow.start()
    }

    func cancelReload() {
        photoService.cancelAll()
        photoAlbumService.cancelAll()
        isDownloadInProgress = false
    }

    func clearFolder() -> Result<Void> {
        return photoStorageService.load()
            .flatMap { resources -> Result<[AnyResult<PhotoResource>]> in
                return self.photoStorageService.remove(resources)
            }.flatMap { results -> Result<Void> in
                let badResults = results.filter { $0.result.isFailure }
                if badResults.isEmpty {
                    return .success(())
                } else {
                    let resources = badResults.map { $0.item }
                    return .failure(PhotoError.fileDeleteError(resources))
                }
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
}
