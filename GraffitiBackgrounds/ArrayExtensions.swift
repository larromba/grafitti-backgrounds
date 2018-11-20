import Foundation

extension Array where Element: Equatable {
    @discardableResult
    mutating func remove(_ element: Element) -> Bool {
        guard let index = index(of: element) else {
            return false
        }
        _ = remove(at: index)
        return true
    }
}

extension Array {
    subscript(safe index: Int) -> Element? {
        guard 0..<count ~= index else {
            return nil
        }
        return self[index]
    }
}
