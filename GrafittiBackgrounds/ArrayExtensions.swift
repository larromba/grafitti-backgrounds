import Foundation

extension Array where Element: Equatable {
	mutating func remove(_ element: Element) -> Bool {
		guard let index = index(of: element) else {
			return false
		}
		_ = remove(at: index)
		return true
	}
}
