import Foundation

protocol Request {
    var url: URL { get }
    var httpVerb: HTTPVerb { get }
    var body: Data? { get }
    var headers: [String: String]? { get }
}

extension Request {
    var body: Data? {
        return nil
    }

    var headers: [String: String]? {
        return nil
    }

    var urlRequest: URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = httpVerb.rawValue
        request.httpBody = body
        request.allHTTPHeaderFields = headers
        return request
    }
}
