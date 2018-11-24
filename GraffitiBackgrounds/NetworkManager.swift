import Foundation

// sourcery: name = NetworkManager
protocol NetworkManaging: Mockable {
    func fetch<T: Response>(request: Request, completion: @escaping (Result<T>) -> Void)
    func download(_ url: URL, completion: @escaping (Result<URL>) -> Void)
    func cancelAll()
}

final class NetworkManager: NetworkManaging {
    private let urlSession: URLSessioning
    private let queue: OperationQueable

    init(urlSession: URLSessioning, queue: OperationQueable) {
        self.urlSession = urlSession
        self.queue = queue
    }

    func fetch<T: Response>(request: Request, completion: @escaping (Result<T>) -> Void) {
        log("fetching: \(request.httpVerb) \(request.url)")

        let operation = NetworkOperation()
        operation.task = urlSession.dataTask(with: request.urlRequest) { [weak operation] data, response, error in
            defer {
                operation?.finish()
            }
            if let error = error {
                completion(.failure(NetworkError.systemError(error)))
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
                log("fetched: \(request.httpVerb) \(request.url)")
                let response = try T(data: data)
                completion(.success(response))
            } catch {
                completion(.failure(NetworkError.badResponse(error)))
            }
        }
        queue.addOperation(operation)
    }

    func download(_ url: URL, completion: @escaping (Result<URL>) -> Void) {
        log("downloading: \(url)")

        let operation = NetworkOperation()
        operation.task = urlSession.downloadTask(with: url) { [weak operation] tempURL, response, error in
            defer {
                operation?.finish()
            }
            if let error = error {
                completion(.failure(NetworkError.systemError(error)))
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

            log("downloaded: \(url) to: \(tempURL)")
            completion(.success(tempURL))
        }
        queue.addOperation(operation)
    }

    func cancelAll() {
        queue.cancelAllOperations()
    }
}

// MARK: - HTTPURLResponse

private extension HTTPURLResponse {
    var isValidRange: Bool {
        return statusCode >= 200 && statusCode < 400
    }
}
