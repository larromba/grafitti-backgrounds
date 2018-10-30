import AppKit

extension NSColor.Name {
    static var spinner = NSColor.Name("spinner")
}

extension NSColor {
    static func named(_ name: NSColor.Name, fromBundle bundle: Bundle? = nil) -> NSColor {
        guard let color = NSColor(named: name, bundle: bundle) else {
            assertionFailure("missing color named: \(name) in bundle: \(String(describing: bundle?.bundleIdentifier))")
            // swiftlint:disable object_literal
            return NSColor(red: 255.0 / 255.0, green: 105.0 / 255.0, blue: 180.0 / 255.0, alpha: 1.0) // hot pink
        }
        return color
    }
}
