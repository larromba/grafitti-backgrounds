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
        #if DEBUG
        guard ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] == nil else {
            log("app is in test mode")
            return
        }
        #endif
        appController.start()
    }
}
