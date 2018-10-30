import Foundation

enum Result<T> {
    case success(T)
    case failure(Error)

    var value: T? {
        switch self {
        case .success(let value):
            return value
        default:
            return nil
        }
    }
    var error: Error? {
        switch self {
        case .success:
            return nil
        case .failure(let error):
            return error
        }
    }
}
