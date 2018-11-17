import Foundation

enum Result<T> {
    case success(T)
    case failure(Error)

    var isSuccess: Bool {
        switch self {
        case .success: return true
        default: return false
        }
    }
    var isFailure: Bool {
        switch self {
        case .failure: return true
        default: return false
        }
    }
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

    // swiftlint:disable identifier_name
    func map<U>(_ t: @escaping (T) -> U) -> Result<U> {
        switch self {
        case .success(let value):
            return .success(t(value))
        case .failure(let error):
            return .failure(error)
        }
    }

    // swiftlint:disable identifier_name
    func flatMap<U>(_ t: @escaping (T) -> Result<U>) -> Result<U> {
        switch self {
        case .success(let value):
            return t(value)
        case .failure(let error):
            return .failure(error)
        }
    }
}
