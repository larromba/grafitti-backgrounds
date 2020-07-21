import Foundation

extension Result {
    var value: Success? {
        switch self {
        case .success(let value):
            return value
        default:
            return nil
        }
    }
    var error: Error? {
        switch self {
        case .failure(let error):
            return error
        default:
            return nil
        }
    }
}
