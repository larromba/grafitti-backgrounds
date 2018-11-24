import Foundation

// sourcery: name = PhotoStorageService
protocol PhotoStorageServicing: Mockable {
    // sourcery: returnValue = Result.success(())
    func save(_ resources: [PhotoResource]) -> Result<Void>
    // sourcery: returnValue = Result.success([PhotoResource]())
    func load() -> Result<[PhotoResource]>
    // sourcery: returnValue = Result.success([PhotoResource]())
    func remove(_ resources: [PhotoResource]) -> Result<[PhotoResource]>
}

final class PhotoStorageService: PhotoStorageServicing {
    private enum Key: String, Keyable {
        case resource
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
            dataManager.save(data, key: Key.resource)
            return .success(())
        } catch {
            return .failure(PhotoStorageError.encodeError(error))
        }
    }

    func load() -> Result<[PhotoResource]> {
        guard let data = dataManager.load(key: Key.resource) else {
            return .success([])
        }
        do {
            let resources = try decoder.decode([PhotoResource].self, from: data)
            return .success(resources)
        } catch {
            return .failure(PhotoStorageError.decodeError(error))
        }
    }

    func remove(_ resources: [PhotoResource]) -> Result<[PhotoResource]> {
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
        var errors = [Error]()
        resources.forEach { resource in
            do {
                if let fileURL = resource.fileURL, self.fileManager.fileExists(atPath: fileURL.path) {
                    try self.fileManager.removeItem(at: fileURL)
                }
                savedResources.remove(resource)
                results += [resource]
            } catch {
                errors += [PhotoStorageError.fileDeleteError(error)]
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
