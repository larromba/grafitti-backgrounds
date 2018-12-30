import AppKit

protocol PreferencesViewStating {
    var isAutoRefreshEnabled: Bool { get set }
    var isAutoRefreshEnabledState: NSControl.StateValue { get }
    var autoRefreshTimeIntervalHours: TimeInterval { get set }
    var autoRefreshTimeIntervalHoursString: String { get }
    var numberOfPhotos: Int { get set }
    var numberOfPhotosString: String { get }
}

struct PreferencesViewState: PreferencesViewStating {
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

    init(preferences: Preferences) {
        isAutoRefreshEnabled = preferences.isAutoRefreshEnabled
        autoRefreshTimeIntervalHours = preferences.autoRefreshTimeIntervalHours
        numberOfPhotos = preferences.numberOfPhotos
    }
}
