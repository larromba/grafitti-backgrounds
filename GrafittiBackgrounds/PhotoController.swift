import Foundation

protocol PhotoControllerDelegate: AnyObject {
    func photoControllerTimerTriggered(_ photoController: PhotoController)
    func photoController(_ photoController: PhotoController, updatedDownloadPercentage percentage: Double)
    func photoController(_ photoController: PhotoController, didChangeDownloadState inProgress: Bool)
}

// sourcery: name = PhotoController
protocol PhotoControllable: Mockable {
    var isDownloadInProgress: Bool { get }
    var folderURL: URL { get }

    func setPreferences(_ preferences: Preferences)
    func reloadPhotos(completion: @escaping (Result<[PhotoControllerReloadResult]>) -> Void)
    func cancelReload()
    func clearFolder() -> Result<Void>
    func setDelegate(_ delegate: PhotoControllerDelegate)
}

struct PhotoControllerReloadResult {
    let photo: PhotoResource
    let result: Result<Void>
}

final class PhotoController: PhotoControllable {
    enum PhotoError: Error {
        case downloadInProgress
        case notEnoughImages
        case fileDeleteError([PhotoResource])
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
    var folderURL: URL {
        return photoService.saveURL
    }

    init(photoAlbumService: PhotoAlbumServicing,
         photoService: PhotoServicing,
         photoStorageService: PhotoStorageServicing,
         preferences: Preferences = Preferences()) {
        self.photoAlbumService = photoAlbumService
        self.photoService = photoService
        self.photoStorageService = photoStorageService
        self.preferences = preferences
        setupTimer()
    }

    deinit {
        stopTimer()
        photoService.cancelAll()
        photoAlbumService.cancelAll()
    }

    func reloadPhotos(completion: @escaping (Result<[PhotoControllerReloadResult]>) -> Void) {
        guard !isDownloadInProgress else {
            completion(.failure(PhotoError.downloadInProgress))
            return
        }
        setupTimer()
        switch clearFolder() {
        case .success:
            isDownloadInProgress = true
            fetchAlbums(numberOfPhotos: preferences.numberOfPhotos, completion: { [weak self] result in
                self?.isDownloadInProgress = false
                completion(result)
            })
        case .failure(let error):
            completion(.failure(error))
        }
    }

    func cancelReload() {
        photoService.cancelAll()
        photoAlbumService.cancelAll()
        isDownloadInProgress = false
    }

    func clearFolder() -> Result<Void> {
        switch photoStorageService.load() {
        case .success(let resources):
            switch photoStorageService.remove(resources) {
            case .success(let results):
                let badResults = results.filter {
                    switch $0.result {
                    case .success: return false
                    case .failure: return true
                    }
                }
                if badResults.isEmpty {
                    return .success(())
                } else {
                    let resources = badResults.map { $0.resource }
                    return .failure(PhotoError.fileDeleteError(resources))
                }
            case .failure(let error):
                return .failure(error)
            }
        case .failure(let error):
            return .failure(error)
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
        if preferences.isAutoRefreshEnabled {
            startTimer(with: preferences.autoRefreshTimeIntervalSeconds)
        }
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
                             completion: @escaping (Result<[PhotoControllerReloadResult]>) -> Void) {
        photoAlbumService.fetchPhotoAlbums(completion: { [weak self] result in
            switch result {
            case .success(let results):
				let successfulResults = results.filter {
					switch $0.result {
					case .success: return true
					case .failure: return false
					}
				}
				let numOfPossibleDownloads = successfulResults.reduce(0, { $0 + $1.album.resources.count })
				guard numOfPossibleDownloads >= numberOfPhotos else {
					DispatchQueue.main.async {
						completion(.failure(PhotoError.notEnoughImages))
					}
					return
				}
				let albums = successfulResults.map { $0.album }
				self?.downloadPhotos(from: albums, numberOfPhotos: numberOfPhotos, completion: completion)
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        })
    }

    private func downloadPhotos(from albums: [PhotoAlbum],
                                numberOfPhotos: Int,
                                completion: @escaping (Result<[PhotoControllerReloadResult]>) -> Void) {
        var savedResources: [PhotoResource]
        switch photoStorageService.load() {
        case .success(let resources):
            savedResources = resources
        case .failure(let error):
            DispatchQueue.main.async {
                completion(.failure(error))
            }
            return
        }

        let allResources = albums.map { $0.resources }.reduce([], +)
        let group = DispatchGroup()
        var results = [PhotoControllerReloadResult]()

        (0..<numberOfPhotos).forEach { _ in
            group.enter()
            let resource = allResources[Int(arc4random_uniform(UInt32(allResources.count)))]
            photoService.downloadPhoto(resource, completion: { result in
                switch result {
                case .success(let resource):
                    savedResources += [resource]
                    switch self.photoStorageService.save(savedResources) {
                    case .success:
                        results += [PhotoControllerReloadResult(photo: resource, result: .success(()))]
                    case .failure(let error):
                        results += [PhotoControllerReloadResult(photo: resource, result: .failure(error))]
                    }
                case .failure(let error):
                    results += [PhotoControllerReloadResult(photo: resource, result: .failure(error))]
                }
                DispatchQueue.main.async {
                    let percentage = Double(results.count) / Double(numberOfPhotos)
                    self.delegate?.photoController(self, updatedDownloadPercentage: percentage)
                }
                group.leave()
            })
        }

        group.notify(queue: .main) {
            self.isDownloadInProgress = false
            let successfulResults = results.filter {
                switch $0.result {
                case .success: return true
                case .failure: return false
                }
            }
            guard successfulResults.count >= numberOfPhotos else {
                completion(.failure(PhotoError.notEnoughImages))
                return
            }
            completion(.success(successfulResults))
        }
    }
}
