//
//  PreferencesViewController.swift
//  GrafittiBackgrounds
//
//  Created by Lee Arromba on 03/12/2017.
//  Copyright © 2017 Pink Chicken. All rights reserved.
//

import Cocoa

protocol PreferencesViewControllerDelegate: class {
    func preferencesViewController(_ viewController: PreferencesViewController, didUpdateAutoRefreshIsEnabled isEnabled: Bool)
    func preferencesViewController(_ viewController: PreferencesViewController, didUpdateTimeInterval timeInterval: TimeInterval)
    func preferencesViewController(_ viewController: PreferencesViewController, didUpdateNumberOfPhotos numberOfPhotos: Int)
}

protocol PreferencesViewControllerInterface {
    var autoRefreshCheckBoxTextLabel: NSTextField! { get }
    var autoRefreshCheckBox: NSButton! { get }
    var autoRefreshIntervalTextLabel: NSTextField! { get }
    var autoRefreshIntervalTextField: NSTextField! { get }
    var numberOfPhotosTextLabel: NSTextField! { get }
    var numberOfPhotosTextField: NSTextField! { get }
    var delegate: PreferencesViewControllerDelegate? { get set }
    var viewModel: PreferencesViewModel? { get set }
}

class PreferencesViewController: NSViewController, PreferencesViewControllerInterface {
    weak var autoRefreshCheckBoxTextLabel: NSTextField!
    weak var autoRefreshCheckBox: NSButton!
    weak var autoRefreshIntervalTextLabel: NSTextField!
    weak var autoRefreshIntervalTextField: NSTextField!
    weak var numberOfPhotosTextLabel: NSTextField!
    weak var numberOfPhotosTextField: NSTextField!

    weak var delegate: PreferencesViewControllerDelegate?
    var viewModel: PreferencesViewModel? {
        didSet {
			guard let viewModel = viewModel else { return }
			update(viewModel: viewModel)
        }
    }

    // MARK: - private

    @IBAction private func autoRefreshCheckBoxPressed(_ sender: NSButton) {
        delegate?.preferencesViewController(self, didUpdateAutoRefreshIsEnabled: sender.state == .on)
    }

    private func update(viewModel: PreferencesViewModel) {
        setAutoRefreshTimeInterval(viewModel.autoRefreshTimeIntervalHours)
        setIsAutoRefreshEnabled(viewModel.isAutoRefreshEnabled)
        setNumberOfPhotos(viewModel.numberOfPhotos)
    }

    private func setIsAutoRefreshEnabled(_ isEnabled: Bool) {
        autoRefreshCheckBox.state = isEnabled ? .on : .off
    }

    private func setAutoRefreshTimeInterval(_ timeInterval: TimeInterval) {
        autoRefreshIntervalTextField.stringValue = String(format: "%.0f", timeInterval)
    }

    private func setNumberOfPhotos(_ numberOfPhotos: Int) {
        numberOfPhotosTextField.stringValue = "\(numberOfPhotos)"
    }
}

// MARK: - NSTextFieldDelegate

extension PreferencesViewController: NSTextFieldDelegate {
    override func controlTextDidChange(_ obj: Notification) {
        guard let textField = obj.object as? NSTextField, textField.stringValue.count > 0 else {
            return
        }
        switch textField {
        case numberOfPhotosTextField:
            guard let value = Int(textField.stringValue) else { return }
            delegate?.preferencesViewController(self, didUpdateNumberOfPhotos: value)
        case autoRefreshIntervalTextField:
            guard let value = TimeInterval(textField.stringValue) else { return }
            delegate?.preferencesViewController(self, didUpdateTimeInterval: value)
        default:
            break
        }
    }
}
