@testable import Grafitti_Backgrounds
import XCTest

final class SystemPreferencesTests: XCTestCase {
	func testSystemPreferencesOnMenuClickOpensSystemPreferences() {
		// mocks
		let statusItem = MockLoadingStatusItem()
        let menuController = AppMenuController(statusItem: statusItem, reachability: MockReachability())
		let workspace = MockWorkspace()
		let workspaceController = WorkspaceController(workspace: workspace)
        _ = AppController.testable(workspaceController: workspaceController, menuController: menuController)

		// sut
		statusItem.menu?.click(at: AppMenu.Order.systemPreferences.rawValue)

        // test
		let url = workspace.invocations.find(
			parameter: MockWorkspace.open1.params.url,
			inFunction: MockWorkspace.open1.name
		) as? URL
		XCTAssertEqual(url, SystemPreference.desktopScreenEffects.url)
	}
}
