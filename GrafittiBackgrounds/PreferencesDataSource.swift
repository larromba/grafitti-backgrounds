//
//  PreferencesDataSource.swift
//  GrafittiBackgrounds
//
//  Created by Lee Arromba on 27/02/2018.
//  Copyright © 2018 Pink Chicken. All rights reserved.
//

import Foundation

protocol PreferencesDataSourceInterface {
    func viewModel(for: Preferences) -> PreferencesViewModel
}

class PreferencesDataSource: PreferencesDataSourceInterface {
    func viewModel(for preferences: Preferences) -> PreferencesViewModel {
        return PreferencesViewModel(
            isAutoRefreshEnabled: preferences.isAutoRefreshEnabled,
            autoRefreshTimeIntervalHours: preferences.autoRefreshTimeIntervalHours,
            numberOfPhotos: preferences.numberOfPhotos
        )
    }
}
