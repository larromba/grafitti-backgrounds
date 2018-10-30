import Foundation

struct PhotoResource: Codable {
    let url: URL
    var fileURL: URL?
}

// MARK: - Equatable

extension PhotoResource: Equatable {
	static func == (lhs: PhotoResource, rhs: PhotoResource) -> Bool {
		return
			lhs.url == rhs.url &&
			lhs.fileURL == rhs.fileURL
	}
}
