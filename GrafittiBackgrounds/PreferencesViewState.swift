import AppKit

struct PreferencesViewState {
    var isAutoRefreshEnabled: Bool
    var isAutoRefreshEnabledState: NSControl.StateValue {
        return isAutoRefreshEnabled ? .on : .off
    }
    var autoRefreshTimeIntervalHours: TimeInterval
    var autoRefreshTimeIntervalHoursString: String {
        return String(format: "%.0f", autoRefreshTimeIntervalHours)
    }
    var numberOfPhotos: Int
    var numberOfPhotosString: String {
        return "\(numberOfPhotos)"
    }
}

extension PreferencesViewState {
    init(preferences: Preferences) {
        isAutoRefreshEnabled = preferences.isAutoRefreshEnabled
        autoRefreshTimeIntervalHours = preferences.autoRefreshTimeIntervalHours
        numberOfPhotos = preferences.numberOfPhotos
    }
}
