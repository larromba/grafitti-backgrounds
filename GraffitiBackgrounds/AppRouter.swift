import Foundation

// sourcery: name = AppRouter
protocol AppRouting: Mockable {
    func start()
    func setDelegate(_ delegate: AppRouterDelegate)
}

protocol AppRouterDelegate: AnyObject {
    func router(_ router: AppRouting, handleAction action: AppAction)
}

final class AppRouter: AppRouting {
    private let coordinator: AppCoordinating
    private weak var delegate: AppRouterDelegate?

    init(coordinator: AppCoordinating) {
        self.coordinator = coordinator
        coordinator.setDelegate(self)
    }

    func start() {
        coordinator.start()
    }

    func setDelegate(_ delegate: AppRouterDelegate) {
        self.delegate = delegate
    }
}

// MARK: - AppCoordinatorDelegate

extension AppRouter: AppCoordinatorDelegate {
    func coordinator(_ coordinator: AppCoordinating, handleAction action: AppAction) {
        delegate?.router(self, handleAction: action)
    }
}
