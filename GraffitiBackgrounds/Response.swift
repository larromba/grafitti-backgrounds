import Foundation

protocol Response {
    var data: Data { get }

    init(data: Data) throws
}
