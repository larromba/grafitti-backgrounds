import Foundation

// sourcery: name = PhotoStorageService
protocol PhotoStorageServicing: Mockable {
    func save(_ resources: [PhotoResource]) -> Result<Void, PhotoStorageError>
    func load() -> Result<[PhotoResource], PhotoStorageError>
    func remove(_ resources: [PhotoResource]) -> Result<[PhotoResource], PhotoStorageError>
}

final class PhotoStorageService: PhotoStorageServicing {
    private enum Key: String, Keyable {
        case resource
    }

    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private let dataManager: DataManaging
    private let fileManager: FileManaging

    init(dataManager: DataManaging, fileManager: FileManaging) {
        self.dataManager = dataManager
        self.fileManager = fileManager
    }

    func save(_ resources: [PhotoResource]) -> Result<Void, PhotoStorageError> {
        do {
            let data = try encoder.encode(resources)
            dataManager.save(data, key: Key.resource)
            return .success(())
        } catch {
            return .failure(.encodeError(error))
        }
    }

    func load() -> Result<[PhotoResource], PhotoStorageError> {
        guard let data = dataManager.load(key: Key.resource) else {
            return .success([])
        }
        do {
            let resources = try decoder.decode([PhotoResource].self, from: data)
            return .success(resources)
        } catch {
            return .failure(.decodeError(error))
        }
    }

    func remove(_ resources: [PhotoResource]) -> Result<[PhotoResource], PhotoStorageError> {
        guard !resources.isEmpty else {
            return .success([])
        }

        var savedResources: [PhotoResource]
        switch load() {
        case .success(let resources):
            savedResources = resources
        case .failure(let error):
            return .failure(error)
        }

        var results = [PhotoResource]()
        var errors = [PhotoStorageError]()
        resources.forEach { resource in
            do {
                if let fileURL = resource.fileURL, self.fileManager.fileExists(atPath: fileURL.path) {
                    try self.fileManager.removeItem(at: fileURL)
                }
                savedResources.remove(resource)
                results += [resource]
            } catch {
                errors += [.fileDeleteError(error)]
            }
        }

        guard !results.isEmpty else {
            return .failure(errors[0])
        }

        switch save(savedResources) {
        case .success:
            return .success(results)
        case .failure(let error):
            return .failure(error)
        }
    }
}
