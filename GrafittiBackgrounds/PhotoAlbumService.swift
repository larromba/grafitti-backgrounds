import Cocoa

// sourcery: name = PhotoAlbumService
protocol PhotoAlbumServicing: Mockable {
    func fetchPhotoAlbums(completion: @escaping (Result<[PhotoAlbumServiceFetchResult]>) -> Void)
    func fetchPhotoResources(in album: PhotoAlbum, completion: @escaping (Result<[PhotoResource]>) -> Void)
    func cancelAll()
}

struct PhotoAlbumServiceFetchResult {
    let album: PhotoAlbum
    let result: Result<Void>
}

final class PhotoAlbumService: PhotoAlbumServicing {
    private let networkManager: NetworkManaging

    init(networkManager: NetworkManaging) {
        self.networkManager = networkManager
    }

    func fetchPhotoAlbums(completion: @escaping (Result<[PhotoAlbumServiceFetchResult]>) -> Void) {
        let request = PhotoAlbumsRequest()

        networkManager.fetch(request: request, completion: { [weak self] (result: Result<PhotoAlbumsResponse>) in
            switch result {
            case .success(let response):
                self?.handleResponse(response, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }

    func fetchPhotoResources(in album: PhotoAlbum, completion: @escaping (Result<[PhotoResource]>) -> Void) {
        let request = PhotoResourceRequest(album: album)
        networkManager.fetch(request: request, completion: { (result: Result<PhotoResourceResponse>) in
            completion(result.flatMap { response -> Result<[PhotoResource]> in
                return .success(response.photoResources)
            })
        })
    }

    func cancelAll() {
        networkManager.cancelAll()
    }

    // MARK: - private

    private func handleResponse(_ response: PhotoAlbumsResponse,
                                completion: @escaping (Result<[PhotoAlbumServiceFetchResult]>) -> Void) {
        var albums = response.photoAlbums
        let group = DispatchGroup()
        var results = [PhotoAlbumServiceFetchResult]()
        for (index, album) in albums.enumerated() {
            group.enter()
            self.fetchPhotoResources(in: album, completion: { result in
                switch result {
                case .success(let resources):
                    albums[index].resources = resources
                    results += [PhotoAlbumServiceFetchResult(album: albums[index], result: .success(()))]
                case .failure(let error):
                    results += [PhotoAlbumServiceFetchResult(album: albums[index], result: .failure(error))]
                }
                group.leave()
            })
        }
        group.notify(queue: .global()) {
            // if user cancelled, return the error
            let isCancelledResults = results.filter { ($0.result.error as? NetworkError)?.isCancelled ?? false }
			guard isCancelledResults.isEmpty else {
				completion(.failure(isCancelledResults[0].result.error!))
				return
			}
            completion(.success(results))
        }
    }
}
