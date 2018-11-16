import Foundation

enum SystemPreference {
    case desktopScreenEffects

    var url: URL {
        switch self {
        case .desktopScreenEffects:
            return URL(fileURLWithPath: "/System/Library/PreferencePanes/DesktopScreenEffectsPref.prefPane")
        }
    }
}
