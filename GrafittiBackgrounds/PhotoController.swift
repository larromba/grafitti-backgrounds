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
    func cancelReload() -> Result<Void>
    func clearFolder() -> Result<Void>
    func setDelegate(_ delegate: PhotoControllerDelegate)
}

final class PhotoController: PhotoControllable {
    private struct ReloadResult {
        let photo: PhotoResource
        let result: Result<Void>
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

    func reloadPhotos(completion: @escaping (Result<[PhotoResource]>) -> Void) {
        guard !isDownloadInProgress else {
            completion(.failure(PhotoError.downloadInProgress))
            return
        }
        setupTimer()
        isDownloadInProgress = true
        fetchAlbums(numberOfPhotos: preferences.numberOfPhotos, completion: { [weak self] result in
            guard let `self` = self else { return }
            DispatchQueue.main.async {
                self.isDownloadInProgress = false
                completion(result
                    .flatMap { resources -> Result<[PhotoResource]> in
                        switch self.clearFolder() {
                        case .success:
                            return .success(resources)
                        case .failure(let error):
                            return .failure(error)
                        }
                    }.flatMap { resources -> Result<[PhotoResource]> in
                        return self.movePhotos(resources)
                    }.flatMap {  resources -> Result<[PhotoResource]> in
                        switch self.photoStorageService.save(resources) {
                        case .success:
                            return .success(resources)
                        case .failure(let error):
                            return .failure(error)
                        }
                    }
                )
            }
        })
    }

    func cancelReload() -> Result<Void> {
        photoService.cancelAll()
        photoAlbumService.cancelAll()
        isDownloadInProgress = false
        return .success(())
    }

    func clearFolder() -> Result<Void> {
        return photoStorageService.load()
            .flatMap { resources -> Result<[PhotoStorageServiceDeletionResult]> in
                return self.photoStorageService.remove(resources)
            }.flatMap { results -> Result<Void> in
                let badResults = results.filter { $0.result.isFailure }
                if badResults.isEmpty {
                    return .success(())
                } else {
                    let resources = badResults.map { $0.resource }
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

    private func fetchAlbums(numberOfPhotos: Int,
                             completion: @escaping (Result<[PhotoResource]>) -> Void) {
        photoAlbumService.fetchPhotoAlbums(completion: { [weak self] result in
            switch result {
            case .success(let results):
                let successfulResults = results.filter { $0.result.isSuccess }
                let numOfPossibleDownloads = successfulResults.reduce(0, { $0 + $1.album.resources.count })
                guard numOfPossibleDownloads >= numberOfPhotos else {
                    completion(.failure(PhotoError.notEnoughImagesAvailable))
                    return
                }
                let albums = successfulResults.map { $0.album }
                self?.downloadPhotos(from: albums, numberOfPhotos: numberOfPhotos, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }

    private func downloadPhotos(from albums: [PhotoAlbum],
                                numberOfPhotos: Int,
                                completion: @escaping (Result<[PhotoResource]>) -> Void) {
        let allResources = albums.map { $0.resources }.reduce([], +)
        let group = DispatchGroup()
        var results = [ReloadResult]()

        (0..<numberOfPhotos).forEach { _ in
            group.enter()
            let resource = allResources[Int(arc4random_uniform(UInt32(allResources.count)))]
            photoService.downloadPhoto(resource, completion: { result in
                switch result {
                case .success(let resource):
                    results += [ReloadResult(photo: resource, result: .success(()))]
                case .failure(let error):
                    results += [ReloadResult(photo: resource, result: .failure(error))]
                }
                let percentage = Double(results.count) / Double(numberOfPhotos)
                DispatchQueue.main.async {
                    self.delegate?.photoController(self, updatedDownloadPercentage: percentage)
                }
                group.leave()
            })
        }

        group.notify(queue: .global()) {
            let photoResources = results.filter { $0.result.isSuccess }.map { return $0.photo }
            guard photoResources.count >= numberOfPhotos else {
                completion(.failure(PhotoError.notEnoughImagesDownloaded))
                return
            }
            completion(.success(photoResources))
        }
    }

    private func movePhotos(_ resources: [PhotoResource]) -> Result<[PhotoResource]> {
        let results = resources.map { photoService.movePhoto($0, to: photoFolderURL) }
        let failed = results.filter { $0.isFailure }
        guard failed.isEmpty else {
            return .failure(failed[0].error!)
        }
        return .success(results.compactMap { $0.value })
    }
}
