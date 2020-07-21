import Foundation

// sourcery: name = App
protocol Apping: Mockable {
    func start()
}

final class App: Apping {
    private let router: AppRouting
    private let application: Applicationable

    init(router: AppRouting, application: Applicationable) {
        self.router = router
        self.application = application
        router.setDelegate(self)
    }

    func start() {
        router.start()
    }
}

// MARK: - AppRouterDelegate

extension App: AppRouterDelegate {
    func router(_ router: AppRouting, handleAction action: AppAction) {
        switch action {
        case .bringToFront: application.activate(ignoringOtherApps: true)
        case .openAbout: application.orderFrontStandardAboutPanel(self)
        case .terminate: application.terminate(self)
        }
    }
}
