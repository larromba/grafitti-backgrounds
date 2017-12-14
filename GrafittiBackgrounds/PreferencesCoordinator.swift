//
//  PreferencesCoordinator.swift
//  GrafittiBackgrounds
//
//  Created by Lee Arromba on 03/12/2017.
//  Copyright © 2017 Pink Chicken. All rights reserved.
//

import Cocoa

protocol PreferencesCoordinatorDelegate: class {
    func preferencesCoordinator(_ coordinator: PreferencesCoordinator, didUpdatePreferences preferences: Preferences)
}

protocol PreferencesCoordinatorInterface {
    var windowController: NSWindowControllerInterface { get }
    var preferencesViewController: PreferencesViewControllerInterface { get }
    var preferencesService: PreferencesServiceInterface { get }
    var preferences: Preferences { get }
    var delegate: PreferencesCoordinatorDelegate? { get set }

    func open()
}

class PreferencesCoordinator: PreferencesCoordinatorInterface {
    let windowController: NSWindowControllerInterface
    var preferencesViewController: PreferencesViewControllerInterface
    let preferencesService: PreferencesServiceInterface
    var preferences: Preferences

    weak var delegate: PreferencesCoordinatorDelegate?

    init(windowController: NSWindowControllerInterface, preferencesService: PreferencesServiceInterface) {
        self.windowController = windowController
        self.preferencesService = preferencesService

        preferences = preferencesService.load() ?? Preferences()

        preferencesViewController = windowController.contentViewController as! PreferencesViewControllerInterface
        preferencesViewController.delegate = self
    }

    func open() {
        windowController.showWindow(self)
        load(preferences)
    }

    // MARK: - private

    private func save(_ preferences: Preferences) {
        preferencesService.save(preferences)
        delegate?.preferencesCoordinator(self, didUpdatePreferences: preferences)
    }

    private func load(_ preferences: Preferences) {
        preferencesViewController.setAutoRefreshTimeInterval(preferences.autoRefreshTimeIntervalHours)
        preferencesViewController.setIsAutoRefreshEnabled(preferences.isAutoRefreshEnabled)
        preferencesViewController.setNumberOfPhotos(preferences.numberOfPhotos)
    }
}

extension PreferencesCoordinator: PreferencesViewControllerDelegate {
    func preferencesViewController(_ viewController: PreferencesViewController, didUpdateNumberOfPhotos numberOfPhotos: Int) {
        preferences.numberOfPhotos = numberOfPhotos
        save(preferences)
    }

    func preferencesViewController(_ viewController: PreferencesViewController, didUpdateAutoRefreshIsEnabled isEndabled: Bool) {
        preferences.isAutoRefreshEnabled = isEndabled
        save(preferences)
    }

    func preferencesViewController(_ viewController: PreferencesViewController, didUpdateTimeInterval timeInterval: TimeInterval) {
        preferences.autoRefreshTimeIntervalHours = timeInterval
        save(preferences)
    }
}
