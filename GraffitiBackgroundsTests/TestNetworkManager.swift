import Foundation
@testable import Grafitti_Backgrounds

struct FetchStub {
    let url: URL
    let resource: TestResource
}

struct DownloadStub {
    let url: URL
    let writeURL: URL
    let data: Data
}

final class TestNetworkManager: NetworkManaging {
    private let fetchStubs: [FetchStub]?
    private let downloadStubs: [DownloadStub]?

    init(fetchStubs: [FetchStub]?, downloadStubs: [DownloadStub]?) {
        self.fetchStubs = fetchStubs
        self.downloadStubs = downloadStubs
    }

    func fetch<T>(request: Request, completion: @escaping (Result<T>) -> Void) where T: Response {
        guard let stub = fetchStubs?.first(where: { $0.url == request.url }) else {
            assertionFailure("expected stub for \(request.url)")
            return
        }
        do {
            let response = try T(data: stub.resource.load())
            completion(.success(response))
        } catch {
            log_error(error.localizedDescription)
            completion(.failure(NetworkError.badResponse(error)))
        }
    }

    func download(_ url: URL, completion: @escaping (Result<URL>) -> Void) {
        guard let stub = downloadStubs?.first(where: { $0.url == url }) else {
            assertionFailure("expected stub for \(url)")
            return
        }
        do {
            try stub.data.write(to: stub.writeURL)
            completion(.success(stub.writeURL))
        } catch {
            log_error(error.localizedDescription)
            completion(.failure(NetworkError.badResponse(error)))
        }
    }

    func cancelAll() {}
}
