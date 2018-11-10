@testable import Grafitti_Backgrounds
import XCTest

class HelpTests: XCTestCase {
    func testHelpOnMenuClickOpensURL() {
        // mocks
        let statusItem = MockLoadingStatusItem()
        let menuController = AppMenuController(statusItem: statusItem, reachability: MockReachability())
        let workspace = MockWorkspace()
        let workspaceController = WorkspaceController(workspace: workspace)

        // sut
        _ = AppController.testable(workspaceController: workspaceController, menuController: menuController)

        // test
        guard let menu = statusItem.menu, menu.click(at: AppMenu.Order.help.rawValue) else {
            XCTFail("expected menu to click")
            return
        }
        let parameter = workspace.invocations.find(
            parameter: MockWorkspace.open1.params.url,
            inFunction: MockWorkspace.open1.name
        ) as? URL
        XCTAssertEqual(parameter?.absoluteString, "http://github.com/larromba/grafitti-backgrounds")
    }
}
