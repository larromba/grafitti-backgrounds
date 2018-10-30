import Cocoa

enum PhotoResponseError: Error {
	case malformedHTML
	case missingImageURL
	case malformedImageURL
}

final class PhotoResponse: Response {
	typealias ErrorType = PhotoResponseError

    let data: Data
    let imageURL: URL

    init(data: Data) throws {
        self.data = data
        guard let html = String(data: data, encoding: .utf8) else {
            throw PhotoResponseError.malformedHTML
        }
        let regex = try NSRegularExpression(pattern: "data-url=\\\"[\\w:\\/.-]+\\\"", options: [])
        let matches = regex.matches(in: html, options: [], range: NSRange(location: 0, length: html.count))
        guard let result = matches.first, let range = Range(result.range, in: html) else {
            throw PhotoResponseError.missingImageURL
        }
        let urlString = String(html[range])
            .appending("=w2148-h1610-no")
            .replacingOccurrences(of: "data-url=", with: "")
            .replacingOccurrences(of: "\"", with: "")
        guard let url = URL(string: urlString) else {
            throw PhotoResponseError.malformedImageURL
        }
        self.imageURL = url
    }
}
