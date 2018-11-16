import Foundation

extension Bundle {
    static var appName: String {
        return main.infoDictionary?["CFBundleName"] as? String ?? "GrafittiBackgrounds" // fallback
    }
}
