//
//  PreferencesViewController.swift
//  GooglePhotosBackground
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

class PreferencesViewController: NSViewController {
    @IBOutlet private weak var autoRefreshCheckBoxTextLabel: NSTextField!
    @IBOutlet private weak var autoRefreshCheckBox: NSButton!
    @IBOutlet private weak var autoRefreshIntervalTextLabel: NSTextField!
    @IBOutlet private weak var autoRefreshIntervalTextField: NSTextField!
    @IBOutlet private weak var numberOfPhotosTextLabel: NSTextField!
    @IBOutlet private weak var numberOfPhotosTextField: NSTextField!

    weak var delegate: PreferencesViewControllerDelegate?

    func setIsAutoRefreshEnabled(_ isEnabled: Bool) {
        autoRefreshCheckBox.state = isEnabled ? .on : .off
    }

    func setAutoRefreshTimeInterval(_ timeInterval: TimeInterval) {
        autoRefreshIntervalTextField.stringValue = String(format: "%.0f", timeInterval)
    }

    func setNumberOfPhotos(_ numberOfPhotos: Int) {
        numberOfPhotosTextField.stringValue = "\(numberOfPhotos)"
    }

    // MARK: - private

    @IBAction private func autoRefreshCheckBoxPressed(_ sender: NSButton) {
        delegate?.preferencesViewController(self, didUpdateAutoRefreshIsEnabled: sender.state == .on)
    }
}

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
