import Cocoa

final class NetworkOperation: BaseOperation {
    var task: URLSessionTask?

    override var isConcurrent: Bool {
        return true
    }

    override func execute() {
        task?.resume()
    }

    override func cancel() {
        task?.cancel()
        super.cancel()
    }
}
