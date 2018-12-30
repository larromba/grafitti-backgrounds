import Cocoa

protocol PreferencesViewControllerDelegate: AnyObject {
    func preferencesViewController(_ viewController: PreferencesViewController,
                                   didUpdateViewState viewState: PreferencesViewStating)
}

// sourcery: name = PreferencesViewController, inherits = NSViewController
protocol PreferencesViewControllable: AnyObject, Mockable {
    var viewState: PreferencesViewStating? { get set }

    func setDelegate(_ delegate: PreferencesViewControllerDelegate)
}

final class PreferencesViewController: NSViewController, PreferencesViewControllable {
    @IBOutlet private(set) weak var autoRefreshCheckBoxTextLabel: NSTextField!
    @IBOutlet private(set) weak var autoRefreshCheckBox: NSButton!
    @IBOutlet private(set) weak var autoRefreshIntervalTextLabel: NSTextField!
    @IBOutlet private(set) weak var autoRefreshIntervalTextField: NSTextField!
    @IBOutlet private(set) weak var numberOfPhotosTextLabel: NSTextField!
    @IBOutlet private(set) weak var numberOfPhotosTextField: NSTextField!

    private weak var delegate: PreferencesViewControllerDelegate?
    var viewState: PreferencesViewStating? {
        didSet { _ = viewState.map(bind) }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        _ = viewState.map(bind)
    }

    func setDelegate(_ delegate: PreferencesViewControllerDelegate) {
        self.delegate = delegate
    }

    // MARK: - private

    @IBAction private func autoRefreshCheckBoxPressed(_ sender: NSButton) {
        viewState?.isAutoRefreshEnabled = (sender.state == .on)
        notifyDelegateViewStateUpdated()
    }

    private func bind(_ viewState: PreferencesViewStating) {
        guard isViewLoaded else { return }
        autoRefreshCheckBox.state = viewState.isAutoRefreshEnabledState
        autoRefreshIntervalTextField.stringValue = viewState.autoRefreshTimeIntervalHoursString
        numberOfPhotosTextField.stringValue = viewState.numberOfPhotosString
    }

    private func notifyDelegateViewStateUpdated() {
        guard let viewState = viewState else { return }
        delegate?.preferencesViewController(self, didUpdateViewState: viewState)
    }
}

// MARK: - NSTextFieldDelegate

extension PreferencesViewController: NSTextFieldDelegate {
    func controlTextDidChange(_ obj: Notification) {
        guard let textField = obj.object as? NSTextField, !textField.stringValue.isEmpty else { return }
        switch textField {
        case numberOfPhotosTextField:
            viewState?.numberOfPhotos = Int(textField.intValue)
        case autoRefreshIntervalTextField:
            viewState?.autoRefreshTimeIntervalHours = textField.timeIntervalValue
        default:
            break
        }
        notifyDelegateViewStateUpdated()
    }
}
