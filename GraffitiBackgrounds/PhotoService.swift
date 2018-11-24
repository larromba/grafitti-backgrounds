import Cocoa

// sourcery: name = PhotoService
protocol PhotoServicing: Mockable {
    func downloadPhotos(_ resources: [PhotoResource],
                        progress: @escaping (Double) -> Void) -> Async<[PhotoResource]>
    func movePhotos(_ resources: [PhotoResource], toFolder url: URL) -> Result<[PhotoResource]>
    func cancelAll()
}

final class PhotoService: PhotoServicing {
    private let networkManager: NetworkManaging
    private let fileManager: FileManaging

    init(networkManager: NetworkManaging, fileManager: FileManaging) {
        self.networkManager = networkManager
        self.fileManager = fileManager
    }

    func downloadPhotos(_ resources: [PhotoResource],
                        progress: @escaping (Double) -> Void) -> Async<[PhotoResource]> {
        return Async { completion in
            async({
                let fetchDownloadURLOperations = resources.map { self.fetchDownloadURL(resource: $0) }
                let fetchResults = try awaitAll(fetchDownloadURLOperations, progress: { percentage in
                    progress(Progress.normalize(progress: percentage, forStepIndex: 0, inTotalSteps: 2))
                })
                let downloadOperations = fetchResults.0.map { self.downloadPhoto(resource: $0) }
                let downloadResults = try awaitAll(downloadOperations, progress: { percentage in
                    progress(Progress.normalize(progress: percentage, forStepIndex: 1, inTotalSteps: 2))
                })
                let isCancelledErrors = downloadResults.1.filter { $0.isNetworkErrorCancelled }
                guard isCancelledErrors.isEmpty else {
                    completion(.failure(isCancelledErrors[0]))
                    return
                }
                completion(.success(downloadResults.0))
            }, onError: { error in
                completion(.failure(error))
            })
        }
    }

    func movePhotos(_ resources: [PhotoResource], toFolder url: URL) -> Result<[PhotoResource]> {
        if !fileManager.fileExists(atPath: url.path) {
            do {
                try fileManager.createDirectory(at: url, withIntermediateDirectories: false, attributes: nil)
            } catch {
                return .failure(PhotoServiceError.cantCreateDownloadFolder(error))
            }
        }

        var results = [PhotoResource]()
        var errors = [Error]()
        for resource in resources {
            guard let fileURL = resource.fileURL else {
                continue
            }
            let newFilePath = url.appendingPathComponent(fileURL.lastPathComponent).path
            let newFileURL = URL(fileURLWithPath: newFilePath)
            do {
                try self.fileManager.moveItem(at: fileURL, to: newFileURL)
                var resource = resource
                resource.fileURL = newFileURL
                results += [resource]
            } catch {
                errors += [PhotoServiceError.moveError(error)]
            }
        }

        guard !results.isEmpty else {
            return .failure(errors[0])
        }
        guard errors.isEmpty else {
            return .failure(PhotoServiceError.someImagesMissingAfterMove)
        }

        return .success(results)
    }

    func cancelAll() {
        networkManager.cancelAll()
    }

    // MARK: - private

    private func fetchDownloadURL(resource: PhotoResource) -> Async<PhotoResource> {
        return Async { completion in
            async({
                let request = PhotoRequest(resource: resource)
                let response: PhotoResponse = try await(self.networkManager.fetch(request: request))
                var resource = resource
                resource.downloadURL = response.imageURL
                completion(.success(resource))
            }, onError: { error in
                completion(.failure(error))
            })
        }
    }

    private func downloadPhoto(resource: PhotoResource) -> Async<PhotoResource> {
        return Async { completion in
            async({
                guard let downloadURL = resource.downloadURL else {
                    completion(.failure(PhotoServiceError.resourceMissingFileURL))
                    return
                }
                let downloadOption = FileDownloadOption.replaceExtension(newFileExtension: ".png")
                let fileURL = try await(self.networkManager.download(downloadURL, option: downloadOption))
                var resource = resource
                resource.fileURL = fileURL
                completion(.success(resource))
            }, onError: { error in
                completion(.failure(error))
            })
        }
    }
}
