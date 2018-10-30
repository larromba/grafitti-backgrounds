import Cocoa

// sourcery: name = PhotoService
protocol PhotoServicing: Mockable {
    var saveURL: URL { get }

    func downloadPhoto(_ resource: PhotoResource, completion: @escaping (Result<PhotoResource>) -> Void)
    func cancelAll()
}

final class PhotoService: PhotoServicing {
    enum PhotoError: Error {
        case badSaveLocation
    }
    private enum FileExtension: String {
        case tmp = ".tmp"
        case png = ".png"
    }

    private let networkManager: NetworkManaging
    private let fileManager: FileManaging
    let saveURL: URL

    init(networkManager: NetworkManaging, fileManager: FileManaging, saveURL: URL) {
        self.networkManager = networkManager
        self.fileManager = fileManager
        self.saveURL = saveURL
    }

    func downloadPhoto(_ resource: PhotoResource, completion: @escaping (Result<PhotoResource>) -> Void) {
        let request = PhotoRequest(resource: resource)
        networkManager.fetch(
            request: request,
            completion: { [weak self] (result: Result<PhotoResponse>) in
                switch result {
                case .success(let response):
                    self?.downloadPhoto(response.imageURL, resource: resource, completion: completion)
                case .failure(let error):
                    completion(.failure(error))
                }
            })
    }

    func cancelAll() {
        networkManager.cancelAll()
    }

    // MARK: - private

    private func downloadPhoto(_ url: URL, resource: PhotoResource,
                               completion: @escaping (Result<PhotoResource>) -> Void) {
        networkManager.download(url, completion: { result in
            switch result {
            case .success(let url):
                let filePath = self.saveURL
                    .appendingPathComponent(url.lastPathComponent)
                    .absoluteString.replacingOccurrences(of: FileExtension.tmp.rawValue,
                                                         with: FileExtension.png.rawValue)
                guard let fileURL = URL(string: filePath) else {
                    completion(.failure(PhotoError.badSaveLocation))
                    return
                }
                do {
                    try self.fileManager.moveItem(at: url, to: fileURL)
                    var resource = resource
                    resource.fileURL = fileURL
                    completion(.success(resource))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
}
