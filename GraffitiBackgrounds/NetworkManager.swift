import Foundation

// sourcery: name = NetworkManager
protocol NetworkManaging: Mockable {
    func fetch<T: Response>(request: Request) -> Async<T>
    func download(_ url: URL, option: FileDownloadOption) -> Async<URL>
    func cancelAll()
}

// TODO: move?
enum FileDownloadOption {
    case move(folder: URL)
    case moveReplaceName(folder: URL, newFileName: String)
    case moveReplaceExtension(folder: URL, newFileExtension: String)
    case replaceExtension(newFileExtension: String)
}

final class NetworkManager: NetworkManaging {
    private let urlSession: URLSessioning
    private let fileManager: FileManaging
    private let queue: OperationQueable

    init(urlSession: URLSessioning, fileManager: FileManaging, queue: OperationQueable) {
        self.urlSession = urlSession
        self.fileManager = fileManager
        self.queue = queue
    }

    func fetch<T: Response>(request: Request) -> Async<T> {
        log("fetching: \(request.httpVerb) \(request.url)")

        return Async { completion in
            let operation = NetworkOperation()
            operation.task = self.urlSession.dataTask(with: request.urlRequest) { [weak operation] data, response, error in
                defer {
                    operation?.finish()
                }
                if let error = error {
                    completion(.failure(error.isURLErrorCancelled ?
                        NetworkError.cancelled : NetworkError.systemError(error)
                        ))
                    return
                }
                guard let data = data else {
                    completion(.failure(NetworkError.noData))
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(.failure(NetworkError.httpErrorCode(500)))
                    return
                }
                guard httpResponse.isValidRange else {
                    completion(.failure(NetworkError.httpErrorCode(httpResponse.statusCode)))
                    return
                }
                do {
                    log("fetched: \(request.httpVerb) ...\(request.url.lastPathComponent)")
                    let response = try T(data: data)
                    completion(.success(response))
                } catch {
                    completion(.failure(NetworkError.badResponse(error)))
                }
            }
            self.queue.addOperation(operation)
        }
    }

    func download(_ url: URL, option: FileDownloadOption) -> Async<URL> {
        log("downloading: \(url)")

        return Async { completion in
            let operation = NetworkOperation()
            operation.task = self.urlSession.downloadTask(with: url) { [weak operation] tempURL, response, error in
                defer {
                    operation?.finish()
                }
                if let error = error {
                    completion(.failure(error.isURLErrorCancelled ?
                        NetworkError.cancelled : NetworkError.systemError(error)
                        ))
                    return
                }
                guard let tempURL = tempURL else {
                    completion(.failure(NetworkError.noData))
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(.failure(NetworkError.httpErrorCode(500)))
                    return
                }
                guard httpResponse.isValidRange else {
                    completion(.failure(NetworkError.httpErrorCode(httpResponse.statusCode)))
                    return
                }

                // must rename / move file else it's removed
                // see https://developer.apple.com/documentation/foundation/urlsession/1411511-downloadtask
                log("downloaded: ...\(url.lastPathComponent) temporarilly to: \(tempURL)")
                switch self.moveFile(at: tempURL, withOption: option) {
                case .success(let fileURL):
                    log("moved: ...\(url.lastPathComponent) finally to: \(fileURL)")
                    completion(.success(fileURL))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
            self.queue.addOperation(operation)
        }
    }

    func cancelAll() {
        queue.cancelAllOperations()
    }

    // MARK: - private

    // swiftlint:disable pattern_matching_keywords
    private func moveFile(at fileURL: URL, withOption option: FileDownloadOption) -> Result<URL> {
        let newFileURL: URL
        switch option {
        case .move(let folderURL):
            newFileURL = URL(fileURLWithPath: folderURL.appendingPathComponent(fileURL.lastPathComponent).path)
        case .moveReplaceName(let folderURL, let newFileName):
            newFileURL = URL(fileURLWithPath: folderURL.appendingPathComponent(newFileName).path)
        case .moveReplaceExtension(let folderURL, let newFileExtension):
            let newFileName = folderURL.path.replacingOccurrences(of: ".tmp", with: newFileExtension)
            newFileURL = URL(fileURLWithPath: folderURL.appendingPathComponent(newFileName).path)
        case .replaceExtension(let newFileExtension):
            let newFileName = fileURL.path.replacingOccurrences(of: ".tmp", with: newFileExtension)
            newFileURL = URL(fileURLWithPath: newFileName)
        }
        do {
            try self.fileManager.moveItem(at: fileURL, to: newFileURL)
            return .success(newFileURL)
        } catch {
            return .failure(error)
        }
    }
}

// MARK: - HTTPURLResponse

private extension HTTPURLResponse {
    var isValidRange: Bool {
        return statusCode >= 200 && statusCode < 400
    }
}

// MARK: - Error

private extension Error {
    var isURLErrorCancelled: Bool {
        return (self as NSError).code == NSURLErrorCancelled
    }
}
