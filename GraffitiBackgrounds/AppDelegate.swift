import Cocoa
import Logging

// sourcery: name = AppDelegate
protocol AppDelegatable: NSApplicationDelegate, Mockable {
    // 🦄
}

final class AppDelegate: NSObject, AppDelegatable {
    private let app: Apping

    init(app: Apping) {
        self.app = app
        super.init()
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        log("prefs: \(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last ?? "")")
        app.start()
    }
}
