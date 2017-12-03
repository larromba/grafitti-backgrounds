//
//  Preference.swift
//  GooglePhotosBackground
//
//  Created by Lee Arromba on 03/12/2017.
//  Copyright © 2017 Pink Chicken. All rights reserved.
//

import Foundation

struct Preferences: Codable {
    var isAutoRefreshEnabled = true
    var autoRefreshTimeIntervalHours: TimeInterval = 24.0
    var autoRefreshTimeIntervalSeconds: TimeInterval {
        return autoRefreshTimeIntervalHours * 60 * 60 // hours * minutes * seconds
    }
    var numberOfPhotos: Int = 50
}
