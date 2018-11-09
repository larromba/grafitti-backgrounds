import Foundation

extension String {
    //TODO: remove
    var localized: String {
        return NSLocalizedString(self, comment: self)
    }
}
