import Cocoa

// sourcery: name = PhotoService
protocol PhotoServicing: Mockable {
    func downloadPhotos(_ resource: [PhotoResource],
                        progress: @escaping (Double) -> Void,
                        completion: @escaping (Result<[AnyResult<PhotoResource>]>) -> Void)
    func movePhotos(_ resources: [PhotoResource], toFolder url: URL) -> [AnyResult<PhotoResource>]
    func cancelAll()
}

final class PhotoService: PhotoServicing {
    private class DownloadFlow: AsyncFlowContext {
        var callBacks = [() -> Void]()
        var finally: (() -> Void)?
        var fetchURLGroup = DispatchGroup()
        var downloadURLGroup = DispatchGroup()
        var resources = [PhotoResource]()
        var downloadResults = [AnyResult<PhotoResource>]()
    }
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

    // swiftlint:disable function_body_length
    func downloadPhotos(_ resources: [PhotoResource],
                        progress: @escaping (Double) -> Void,
                        completion: @escaping (Result<[AnyResult<PhotoResource>]>) -> Void) {
        let flow = DownloadFlow()

        // 1. get photo download urls
        flow.add {
            resources.forEach { resource in
                flow.fetchURLGroup.enter()
                let request = PhotoRequest(resource: resource)
                self.networkManager.fetch(request: request, completion: { (result: Result<PhotoResponse>) in
                    switch result {
                    case .success(let response):
                        var resource = resource
                        resource.downloadURL = response.imageURL
                        flow.resources += [resource]
                    case .failure(let error):
                        completion(.failure(error))
                        flow.finished()
                    }
                    progress(0.5 * (Double(flow.resources.count) / Double(resources.count)))
                    flow.fetchURLGroup.leave()
                })
            }
            flow.fetchURLGroup.notify(queue: .global()) {
                flow.next()
            }
        }

        // 2. download photos
        flow.add {
            flow.resources.forEach({ resource in
                guard let downloadURL = resource.downloadURL else { return }
                flow.downloadURLGroup.enter()
                self.networkManager.download(downloadURL, completion: { result in
                    switch result {
                    case .success(let fileURL):
                        // must rename file else it's removed
                        // see https://developer.apple.com/documentation/foundation/urlsession/1411511-downloadtask
                        let newFilePath = fileURL.path.replacingOccurrences(
                            of: FileExtension.tmp.rawValue,
                            with: FileExtension.png.rawValue
                        )
                        let newfileURL = URL(fileURLWithPath: newFilePath)
                        var resource = resource
                        resource.fileURL = newfileURL
                        do {
                            try self.fileManager.moveItem(at: fileURL, to: newfileURL)
                            flow.downloadResults += [.init(item: resource, result: .success(()))]
                        } catch {
                            flow.downloadResults += [.init(item: resource, result: .failure(error))]
                        }
                    case .failure(let error):
                        flow.downloadResults += [.init(item: resource, result: .failure(error))]
                    }
                    progress(0.5 + (0.5 * (Double(flow.downloadResults.count) / Double(flow.resources.count))))
                    flow.downloadURLGroup.leave()
                })
            })
            flow.downloadURLGroup.notify(queue: .global()) {
                flow.finished()
            }
        }

        // 3. report downloads
        flow.setFinally {
            completion(.success(flow.downloadResults))
        }

        flow.start()
    }

    func movePhotos(_ resources: [PhotoResource], toFolder url: URL) -> [AnyResult<PhotoResource>] {
        var results = [AnyResult<PhotoResource>]()
        for resource in resources {
            guard let fileURL = resource.fileURL else {
                results += [AnyResult(item: resource, result: .failure(PhotoServiceError.resourceMissingFileURL))]
                continue
            }
            let newFilePath = url.appendingPathComponent(fileURL.lastPathComponent).path
            let newFileURL = URL(fileURLWithPath: newFilePath)
            do {
                try self.fileManager.moveItem(at: fileURL, to: newFileURL)
                var resource = resource
                resource.fileURL = newFileURL
                results += [AnyResult(item: resource, result: .success(()))]
            } catch {
                results += [AnyResult(item: resource, result: .failure(error))]
            }
        }
        return results
    }

    func cancelAll() {
        networkManager.cancelAll()
    }
}
