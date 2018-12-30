import Cocoa

extension NSTextField {
    func fireTextChagedEvent(in delegate: NSControlTextEditingDelegate) {
        delegate.controlTextDidChange?(Notification(name: NSNotification.Name(""), object: self))
    }
}
