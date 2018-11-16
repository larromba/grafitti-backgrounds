@testable import Grafitti_Backgrounds
import XCTest

final class HelpTests: XCTestCase {
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

    func testHelpOnMenuClickOpensURL() {
        // mocks
        let env = Environment()
        env.inject()

        // sut
        env.statusItem.menu?.click(at: AppMenu.Order.help.rawValue)

        // test
		let url = env.workspace.invocations.find(MockWorkspace.open1.name).first?
			.parameter(for: MockWorkspace.open1.params.url) as? URL
        XCTAssertEqual(url?.absoluteString, "http://github.com/larromba/grafitti-backgrounds")
    }
}
