import Cocoa

// TODO: rename NetworkManager?
// sourcery: name = FileManager2
protocol FileManaging: Mockable {
    func removeItem(at URL: URL) throws
    func moveItem(at srcURL: URL, to dstURL: URL) throws
    func createDirectory(at url: URL,
                         withIntermediateDirectories createIntermediates: Bool,
                         attributes: [FileAttributeKey: Any]?) throws
    // sourcery: returnValue = true
    func fileExists(atPath path: String) -> Bool
}
extension FileManager: FileManaging {}
