import AppKit

extension NSTextField {
    var timeIntervalValue: TimeInterval {
        return TimeInterval(stringValue) ?? 0
    }
}
