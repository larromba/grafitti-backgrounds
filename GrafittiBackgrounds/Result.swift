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
}
