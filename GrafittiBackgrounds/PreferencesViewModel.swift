//
//  PreferencesViewModel.swift
//  GrafittiBackgrounds
//
//  Created by Lee Arromba on 27/02/2018.
//  Copyright © 2018 Pink Chicken. All rights reserved.
//

import Foundation

struct PreferencesViewModel {
    let isAutoRefreshEnabled: Bool
    let autoRefreshTimeIntervalHours: TimeInterval
    let numberOfPhotos: Int
}

extension PreferencesViewModel {
	init(preferences: Preferences) {
		isAutoRefreshEnabled = preferences.isAutoRefreshEnabled
		autoRefreshTimeIntervalHours = preferences.autoRefreshTimeIntervalHours
		numberOfPhotos = preferences.numberOfPhotos
	}
}
