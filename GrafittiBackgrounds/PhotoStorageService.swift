import Foundation

// sourcery: name = PhotoStorageService
protocol PhotoStorageServicing: Mockable {
    func save(_ resources: [PhotoResource]) -> Result<Void>
    func load() -> Result<[PhotoResource]>
    func remove(_ resources: [PhotoResource]) -> Result<[PhotoStorageServiceDeletionResult]>
}

struct PhotoStorageServiceDeletionResult {
    let resource: PhotoResource
    let result: Result<Void>
}

final class PhotoStorageService: PhotoStorageServicing {
    private enum Key: String, Keyable {
        case photoResource
    }

    private let encoder = PropertyListEncoder()
    private let decoder = PropertyListDecoder()
    private let dataManager: DataManaging
    private let fileManager: FileManaging

    init(dataManager: DataManaging, fileManager: FileManaging) {
        self.dataManager = dataManager
        self.fileManager = fileManager
    }

    func save(_ resources: [PhotoResource]) -> Result<Void> {
        do {
            let data = try encoder.encode(resources)
            dataManager.save(data, key: Key.photoResource)
            return .success(())
        } catch {
            return .failure(PhotoStorageError.encodeError(error))
        }
    }

    func load() -> Result<[PhotoResource]> {
        let result = dataManager.load(key: Key.photoResource)
        switch result {
        case .success(let data):
            do {
                let resources = try decoder.decode([PhotoResource].self, from: data)
                return .success(resources)
            } catch {
                return .failure(PhotoStorageError.decodeError(error))
            }
        case .failure(let error):
            switch error {
            case DataError.dataNotFound:
                return .success([])
            default:
                return .failure(error)
            }
        }
    }

    func remove(_ resources: [PhotoResource]) -> Result<[PhotoStorageServiceDeletionResult]> {
        var savedResources: [PhotoResource]
        switch load() {
        case .success(let resources):
            savedResources = resources
        case .failure(let error):
            return .failure(error)
        }

        var results = [PhotoStorageServiceDeletionResult]()
        resources.forEach { resource in
            do {
                if let fileURL = resource.fileURL, self.fileManager.fileExists(atPath: fileURL.path) {
                    try self.fileManager.removeItem(at: fileURL)
                }
                if savedResources.remove(resource) {
                    results += [PhotoStorageServiceDeletionResult(
                        resource: resource,
                        result: .success(())
                        )]
                } else {
                    results += [PhotoStorageServiceDeletionResult(
                        resource: resource,
                        result: .failure(PhotoStorageError.noRecord)
                        )]
                }
            } catch {
                results += [PhotoStorageServiceDeletionResult(
                    resource: resource,
                    result: .failure(PhotoStorageError.fileDeleteError(error))
                    )]
            }
        }

        switch save(savedResources) {
        case .success:
            return .success(results)
        case .failure(let error):
            return .failure(error)
        }
    }
}
