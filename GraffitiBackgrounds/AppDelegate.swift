import Cocoa
import Logging

// sourcery: name = AppDelegate
protocol AppDelegatable: NSApplicationDelegate, Mockable {
    // 🦄
}

final class AppDelegate: NSObject, AppDelegatable {
    private let appController: AppControllable

    init(appController: AppControllable) {
        self.appController = appController
        super.init()
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        log("prefs: \(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last ?? "")")
        appController.start()
    }
}
