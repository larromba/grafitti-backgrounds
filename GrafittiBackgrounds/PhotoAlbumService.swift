import Cocoa

// sourcery: name = PhotoAlbumService
protocol PhotoAlbumServicing: Mockable {
    func fetchPhotoAlbums(progress: @escaping (Double) -> Void,
                          completion: @escaping (Result<[AnyResult<PhotoAlbum>]>) -> Void)
    func fetchPhotoResources(in album: PhotoAlbum, completion: @escaping (Result<[PhotoResource]>) -> Void)
    func cancelAll()
}

final class PhotoAlbumService: PhotoAlbumServicing {
    private class FetchAlbumFlow: AsyncFlowContext {
        var callBacks = [() -> Void]()
        var finally: (() -> Void)?
        var albums = [PhotoAlbum]()
        let resourcesGroup = DispatchGroup()
        var results = [AnyResult<PhotoAlbum>]()
    }

    private let networkManager: NetworkManaging

    init(networkManager: NetworkManaging) {
        self.networkManager = networkManager
    }

    func fetchPhotoAlbums(progress: @escaping (Double) -> Void,
                          completion: @escaping (Result<[AnyResult<PhotoAlbum>]>) -> Void) {
        let flow = FetchAlbumFlow()

        // 1. get photo albums
        flow.add {
            let request = PhotoAlbumsRequest()
            self.networkManager.fetch(request: request, completion: { (result: Result<PhotoAlbumsResponse>) in
                switch result {
                case .success(let response):
                    flow.albums = response.photoAlbums
                    flow.next()
                case .failure(let error):
                    completion(.failure(error))
                    flow.finished()
                }
            })
        }

        // 2. get album resources for each album
        flow.add {
            flow.albums.forEach({ album in
                flow.resourcesGroup.enter()
                self.fetchPhotoResources(in: album, completion: { result in
                    switch result {
                    case .success(let resources):
                        var album = album
                        album.resources = resources
                        flow.results += [AnyResult(item: album, result: .success(()))]
                    case .failure(let error):
                        flow.results += [AnyResult(item: album, result: .failure(error))]
                    }
                    progress(Double(flow.results.count) / Double(flow.albums.count))
                    flow.resourcesGroup.leave()
                })
            })
            flow.resourcesGroup.notify(queue: .global()) {
                flow.next()
            }
        }

        // 2. make sure the user didn't cancel, and finish
        flow.add {
            let isCancelledResults = flow.results.filter { ($0.result.error as? NetworkError)?.isCancelled ?? false }
            guard isCancelledResults.isEmpty else {
                completion(.failure(isCancelledResults[0].result.error!))
                return
            }
            completion(.success(flow.results))
            flow.finished()
        }

        flow.start()
    }

    func fetchPhotoResources(in album: PhotoAlbum, completion: @escaping (Result<[PhotoResource]>) -> Void) {
        let request = PhotoResourceRequest(album: album)
        networkManager.fetch(request: request, completion: { (result: Result<PhotoResourceResponse>) in
            completion(result.flatMap { response -> Result<[PhotoResource]> in
                return .success(response.resources)
            })
        })
    }

    func cancelAll() {
        networkManager.cancelAll()
    }
}
