import Foundation
@testable import Graffiti_Backgrounds
import Networking

extension TestNetworkManager {
    static func make1PhotoDownloadSuccess(inFolder url: URL) -> TestNetworkManager {
        let fetchStubs = [
            FetchStub(url: API.photoAlbums.url, resource: TestResource.photoAlbumResponse1Album.file),
            FetchStub(url: URL(string: "https://photos.app.goo.gl/test")!,
                      resource: TestResource.photoResourceResponse1Photo.file),
            FetchStub(url: URL(string: "https://photos.google.com/share/test/photo/test")!,
                      resource: TestResource.photoResponse1Photo.file)
        ]
        let downloadStubs = [
            DownloadStub(url: URL(string: "https://lh3.googleusercontent.com/test=w2148-h1610-no")!,
                         writeURL: url.appendingPathComponent("test.png"),
                         data: Data())
        ]
        return TestNetworkManager(fetchStubs: fetchStubs, downloadStubs: downloadStubs)
    }

    static func make0PhotosAvailable() -> TestNetworkManager {
        let fetchStubs = [
            FetchStub(url: API.photoAlbums.url, resource: TestResource.photoAlbumResponse1Album.file),
            FetchStub(url: URL(string: "https://photos.app.goo.gl/test")!,
                      resource: TestResource.photoResponse0Photo.file)
        ]
        return TestNetworkManager(fetchStubs: fetchStubs, downloadStubs: nil)
    }

    static func make0PhotoDownloadSuccess() -> TestNetworkManager {
        let fetchStubs = [
            FetchStub(url: API.photoAlbums.url, resource: TestResource.photoAlbumResponse1Album.file),
            FetchStub(url: URL(string: "https://photos.app.goo.gl/test")!,
                      resource: TestResource.photoResourceResponse1Photo.file),
            FetchStub(url: URL(string: "https://photos.google.com/share/test/photo/test")!,
                      resource: TestResource.photoResponse1Photo.file)
        ]
        let downloadStubs = [
            DownloadStub(url: URL(string: "https://lh3.googleusercontent.com/test=w2148-h1610-no")!,
                         statusCode: 500,
                         writeURL: URL.makeTemporaryFolderURL(),
                         data: Data())
        ]
        return TestNetworkManager(fetchStubs: fetchStubs, downloadStubs: downloadStubs)
    }
}
