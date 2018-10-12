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

// sourcery: name = PreferencesViewController, inherits = NSViewController
protocol PreferencesViewControllable: Mockable {
	// sourcery: value = NSTextField()
    var autoRefreshCheckBoxTextLabel: ReadOnlyTextField! { get }
	// sourcery: value = NSButton()
    var autoRefreshCheckBox: ReadOnlyButton! { get }
	// sourcery: value = NSTextField()
    var autoRefreshIntervalTextLabel: ReadOnlyTextField! { get }
	// sourcery: value = NSTextField()
    var autoRefreshIntervalTextField: ReadOnlyTextField! { get }
	// sourcery: value = NSTextField()
    var numberOfPhotosTextLabel: ReadOnlyTextField! { get }
	// sourcery: value = NSTextField()
    var numberOfPhotosTextField: ReadOnlyTextField! { get }
    var delegate: PreferencesViewControllerDelegate? { get set }
    var viewModel: PreferencesViewModel? { get set }
}

final class PreferencesViewController: NSViewController, PreferencesViewControllable {
	@IBOutlet private weak var autoRefreshCheckBoxTextLabelInput: NSTextField!
	var autoRefreshCheckBoxTextLabel: ReadOnlyTextField! {
		return autoRefreshCheckBoxTextLabelInput
	}
	@IBOutlet private weak var autoRefreshCheckBoxInput: NSButton!
	var autoRefreshCheckBox: ReadOnlyButton! {
		return autoRefreshCheckBoxInput
	}
	@IBOutlet private weak var autoRefreshIntervalTextLabelInput: NSTextField!
	var autoRefreshIntervalTextLabel: ReadOnlyTextField! {
		return autoRefreshIntervalTextLabelInput
	}
	@IBOutlet private weak var autoRefreshIntervalTextFieldInput: NSTextField!
	var autoRefreshIntervalTextField: ReadOnlyTextField! {
		return autoRefreshIntervalTextFieldInput
	}
	@IBOutlet private weak var numberOfPhotosTextLabelInput: NSTextField!
	var numberOfPhotosTextLabel: ReadOnlyTextField! {
		return numberOfPhotosTextLabelInput
	}
	@IBOutlet private weak var numberOfPhotosTextFieldInput: NSTextField!
	var numberOfPhotosTextField: ReadOnlyTextField! {
		return numberOfPhotosTextFieldInput
	}

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
        autoRefreshCheckBoxInput.state = isEnabled ? .on : .off
    }

    private func setAutoRefreshTimeInterval(_ timeInterval: TimeInterval) {
        autoRefreshIntervalTextFieldInput.stringValue = String(format: "%.0f", timeInterval)
    }

    private func setNumberOfPhotos(_ numberOfPhotos: Int) {
        numberOfPhotosTextFieldInput.stringValue = "\(numberOfPhotos)"
    }
}

// MARK: - NSTextFieldDelegate

extension PreferencesViewController: NSTextFieldDelegate {
    override func controlTextDidChange(_ obj: Notification) {
        guard let textField = obj.object as? NSTextField, textField.stringValue.count > 0 else {
            return
        }
        switch textField {
        case numberOfPhotosTextFieldInput:
            guard let value = Int(textField.stringValue) else { return }
            delegate?.preferencesViewController(self, didUpdateNumberOfPhotos: value)
        case autoRefreshIntervalTextFieldInput:
            guard let value = TimeInterval(textField.stringValue) else { return }
            delegate?.preferencesViewController(self, didUpdateTimeInterval: value)
        default:
            break
        }
    }
}
