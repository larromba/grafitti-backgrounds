import Foundation

protocol Request {
    var url: URL { get }
    var httpVerb: HTTPVerb { get }
}
