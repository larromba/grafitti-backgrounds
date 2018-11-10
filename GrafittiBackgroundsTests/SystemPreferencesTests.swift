@testable import Grafitti_Backgrounds
import XCTest

class SystemPreferencesTests: XCTestCase {
	func testSystemPreferencesOnMenuClickOpensSystemPreferences() {
		// mocks
		let statusItem = MockLoadingStatusItem()
        let menuController = AppMenuController(statusItem: statusItem, reachability: MockReachability())
		let workspace = MockWorkspace()
		let workspaceController = WorkspaceController(workspace: workspace)

		// sut
		_ = AppController.testable(workspaceController: workspaceController, menuController: menuController)

		// test
		guard let menu = statusItem.menu, menu.click(at: AppMenu.Order.systemPreferences.rawValue) else {
			XCTFail("expected menu to click")
			return
		}
		let url = workspace.invocations.find(
			parameter: MockWorkspace.open1.params.url,
			inFunction: MockWorkspace.open1.name
		) as? URL
		XCTAssertEqual(url, SystemPreference.desktopScreenEffects.url)
	}
}
