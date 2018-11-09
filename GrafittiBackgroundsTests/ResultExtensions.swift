import Foundation
@testable import Grafitti_Backgrounds

extension Result {
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
