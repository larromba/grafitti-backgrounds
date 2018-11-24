import Foundation

protocol Request {
    var url: URL { get }
    var httpVerb: HTTPVerb { get }
    var body: Data? { get }
    var headers: [String: String]? { get }
    var parameters: [String: String]? { get }
}

extension Request {
    var body: Data? {
        return nil
    }
    var headers: [String: String]? {
        return nil
    }
    var parameters: [String: String]? {
        return nil
    }
    var urlRequest: URLRequest {
        var components: URLComponents?
        let finalURL: URL
        if let parameters = parameters {
            components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            components?.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
            finalURL = components?.url ?? url
        } else {
            finalURL = url
        }
        var request = URLRequest(url: finalURL)
        request.httpMethod = httpVerb.rawValue
        request.httpBody = body
        request.allHTTPHeaderFields = headers
        return request
    }
}
