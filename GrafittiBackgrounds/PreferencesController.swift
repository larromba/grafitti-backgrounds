//
//  PreferencesController.swift
//  GrafittiBackgrounds
//
//  Created by Lee Arromba on 03/12/2017.
//  Copyright © 2017 Pink Chicken. All rights reserved.
//

import Cocoa

protocol PreferencesControllerDelegate: class {
    func preferencesController(_ coordinator: PreferencesController, didUpdatePreferences preferences: Preferences)
}

// sourcery: name = PreferencesController
protocol PreferencesControllable: Mockable {
    var windowController: WindowControlling { get }
    var preferencesViewController: PreferencesViewControllable { get }
    var preferencesService: PreferencesServicing { get }
	// sourcery: value = Preferences()
    var preferences: Preferences { get }
    var delegate: PreferencesControllerDelegate? { get set }

    func open()
}

final class PreferencesController: PreferencesControllable {
    let windowController: WindowControlling
    private(set) var preferencesViewController: PreferencesViewControllable
    let preferencesService: PreferencesServicing
    private(set) var preferences: Preferences

    weak var delegate: PreferencesControllerDelegate?

    init(windowController: WindowControlling, preferencesService: PreferencesServicing) {
        self.windowController = windowController
        self.preferencesService = preferencesService

        preferences = preferencesService.load() ?? Preferences()

        preferencesViewController = windowController.contentViewController as! PreferencesViewControllable
        preferencesViewController.delegate = self
    }

    func open() {
        windowController.showWindow(self)
        load(preferences)
    }

    // MARK: - private

    private func save(_ preferences: Preferences) {
        preferencesService.save(preferences)
        delegate?.preferencesController(self, didUpdatePreferences: preferences)
    }

    private func load(_ preferences: Preferences) {
        preferencesViewController.viewModel = PreferencesViewModel(preferences: preferences)
    }

    private func refresh(_ preferences: Preferences) {
        save(preferences)
        load(preferences)
    }
}

// MARK: - PreferencesViewControllerDelegate

extension PreferencesController: PreferencesViewControllerDelegate {
    func preferencesViewController(_ viewController: PreferencesViewController, didUpdateNumberOfPhotos numberOfPhotos: Int) {
        preferences.numberOfPhotos = numberOfPhotos
        refresh(preferences)
    }

    func preferencesViewController(_ viewController: PreferencesViewController, didUpdateAutoRefreshIsEnabled isEndabled: Bool) {
        preferences.isAutoRefreshEnabled = isEndabled
        refresh(preferences)
    }

    func preferencesViewController(_ viewController: PreferencesViewController, didUpdateTimeInterval timeInterval: TimeInterval) {
        preferences.autoRefreshTimeIntervalHours = timeInterval
        refresh(preferences)
    }
}
