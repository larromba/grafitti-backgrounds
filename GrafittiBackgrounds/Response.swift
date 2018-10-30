import Foundation

protocol Response {
    associatedtype ErrorType: Error

    var data: Data { get }

    init(data: Data) throws
}
