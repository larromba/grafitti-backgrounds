import AsyncAwait
import Cocoa
import Networking

// sourcery: name = PhotoAlbumService
protocol PhotoAlbumServicing: Mockable {
    func fetchPhotoAlbums(progress: @escaping (Double) -> Void) -> Async<[PhotoAlbum], Error>
    func cancelAll()
}

final class PhotoAlbumService: PhotoAlbumServicing {
    private let networkManager: NetworkManaging

    init(networkManager: NetworkManaging) {
        self.networkManager = networkManager
    }

    func fetchPhotoAlbums(progress: @escaping (Double) -> Void) -> Async<[PhotoAlbum], Error> {
        return Async { completion in
            async({
                let request = PhotoAlbumsRequest()
                let response: PhotoAlbumsResponse = try await(self.networkManager.fetch(request: request))
                let fetchPhotoResourceOperations = response.photoAlbums.map { self.fetchPhotoResources(for: $0) }
                let fetchPhotoResourceResults = try awaitAll(fetchPhotoResourceOperations, progress: progress)
                let isCancelledErrors = fetchPhotoResourceResults.compactMap { $0.error }
                    .filter { $0.isNetworkErrorCancelled }
                guard isCancelledErrors.isEmpty else {
                    completion(.failure(isCancelledErrors[0]))
                    return
                }
                completion(.success(fetchPhotoResourceResults.compactMap { $0.value }))
            }, onError: { error in
                completion(.failure(error))
            })
        }
    }

    func cancelAll() {
        networkManager.cancelAll()
    }

    // MARK: - private

    private func fetchPhotoResources(for album: PhotoAlbum) -> Async<PhotoAlbum, Error> {
        return Async { completion in
            async({
                let request = PhotoResourceRequest(album: album)
                let response: PhotoResourceResponse = try await(self.networkManager.fetch(request: request))
                var album = album
                album.resources = response.resources
                completion(.success(album))
            }, onError: { error in
                completion(.failure(error))
            })
        }
    }
}
