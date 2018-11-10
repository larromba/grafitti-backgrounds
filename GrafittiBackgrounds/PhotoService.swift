import Cocoa

// sourcery: name = PhotoService
protocol PhotoServicing: Mockable {
    func downloadPhoto(_ resource: PhotoResource, completion: @escaping (Result<PhotoResource>) -> Void)
    func movePhoto(_ resource: PhotoResource, to url: URL) -> Result<PhotoResource>
    func cancelAll()
}

final class PhotoService: PhotoServicing {
    private enum FileExtension: String {
        case tmp = ".tmp"
        case png = ".png"
    }

    private let networkManager: NetworkManaging
    private let fileManager: FileManaging

    init(networkManager: NetworkManaging, fileManager: FileManaging) {
        self.networkManager = networkManager
        self.fileManager = fileManager
    }

    func downloadPhoto(_ resource: PhotoResource, completion: @escaping (Result<PhotoResource>) -> Void) {
        let request = PhotoRequest(resource: resource)
        networkManager.fetch(request: request, completion: { [weak self] (result: Result<PhotoResponse>) in
            switch result {
            case .success(let response):
                self?.downloadPhotoURL(response.imageURL, resource: resource, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }

    func movePhoto(_ resource: PhotoResource, to url: URL) -> Result<PhotoResource> {
        guard let fileURL = resource.fileURL else {
            return .failure(PhotoServiceError.resourceMissingFileURL)
        }
        let newFilePath = url.appendingPathComponent(fileURL.lastPathComponent).path
        let newFileURL = URL(fileURLWithPath: newFilePath)
        do {
            try self.fileManager.moveItem(at: fileURL, to: newFileURL)
            var resource = resource
            resource.fileURL = newFileURL
            return .success(resource)
        } catch {
            return .failure(error)
        }
    }

    func cancelAll() {
        networkManager.cancelAll()
    }

    // MARK: - private

    private func downloadPhotoURL(_ url: URL, resource: PhotoResource,
                                  completion: @escaping (Result<PhotoResource>) -> Void) {
        networkManager.download(url, completion: { result in
            completion(result.flatMap { fileURL -> Result<PhotoResource> in
                do {
                    // must rename file else it's removed
                    // see https://developer.apple.com/documentation/foundation/urlsession/1411511-downloadtask
                    let newFilePath = fileURL.path.replacingOccurrences(
                        of: FileExtension.tmp.rawValue,
                        with: FileExtension.png.rawValue
                    )
                    let newFileURL = URL(fileURLWithPath: newFilePath)
                    try self.fileManager.moveItem(at: fileURL, to: newFileURL)
                    var resource = resource
                    resource.fileURL = newFileURL
                    return .success(resource)
                } catch {
                    return .failure(error)
                }
            })
        })
    }
}
