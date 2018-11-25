@testable import Graffiti_Backgrounds
import Reachability
import XCTest

final class SystemPreferencesTests: XCTestCase {
    private class Environment: TestEnvironment {
        let statusItem = MockLoadingStatusItem()
        lazy var menuController = AppMenuController(statusItem: statusItem, reachability: MockReachability())
        let workspace = MockWorkspace()
        lazy var workspaceController = WorkspaceController(workspace: workspace)
        var appController: AppController?

        func inject() {
            appController = AppController.testable(workspaceController: workspaceController,
                                                   menuController: menuController)
        }
    }

    func testSystemPreferencesOnMenuClickOpensSystemPreferences() {
        // mocks
        let env = Environment()
        env.inject()

        // sut
        env.statusItem.menu?.click(at: AppMenu.Order.systemPreferences.rawValue)

        // test
        let url = env.workspace.invocations.find(MockWorkspace.open1.name).first?
            .parameter(for: MockWorkspace.open1.params.url) as? URL
        XCTAssertEqual(url, SystemPreference.desktopScreenEffects.url)
    }
}
