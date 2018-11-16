import AppKit

// sourcery: name = SharingService
protocol SharingServicing: AnyObject, Mockable {
    var subject: String? { get set }
    var recipients: [String]? { get set }
    var messageBody: String? { get }

    func canPerform(withItems items: [Any]?) -> Bool
    func perform(withItems items: [Any])
}
extension NSSharingService: SharingServicing {}
