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

    func fetch<T: Response>(request: Request) -> Async<T> {
        return Async { completion in
            guard let stub = self.fetchStubs?.first(where: { $0.url == request.url }) else {
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
    }

    func download(_ url: URL, option: FileDownloadOption) -> Async<URL> {
        return Async { completion in
            guard let stub = self.downloadStubs?.first(where: { $0.url == url }) else {
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
    }

    func cancelAll() {}
}
