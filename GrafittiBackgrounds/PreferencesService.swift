//
//  PreferencesService.swift
//  GrafittiBackgrounds
//
//  Created by Lee Arromba on 03/12/2017.
//  Copyright © 2017 Pink Chicken. All rights reserved.
//

import Foundation

// sourcery: name = PreferencesService
protocol PreferencesServicing: Mockable {
    var dataManager: DataManaging { get }

    func save(_ preferences: Preferences)
    func load() -> Preferences?
}

final class PreferencesService: PreferencesServicing {
    private enum Key: String {
        case preferences
    }

    private let encoder = PropertyListEncoder()
    private let decoder = PropertyListDecoder()

    let dataManager: DataManaging

    init(dataManager: DataManaging) {
        self.dataManager = dataManager
    }

    func save(_ preferences: Preferences) {
        do {
            let data = try encoder.encode(preferences)
            dataManager.save(data, key: Key.preferences.rawValue)
        } catch {
            log(error.localizedDescription)
        }
    }

    func load() -> Preferences? {
        guard let data = dataManager.load(key: Key.preferences.rawValue) else {
            return nil
        }
        return try? decoder.decode(Preferences.self, from: data)
    }
}
