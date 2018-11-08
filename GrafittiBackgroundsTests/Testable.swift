import Foundation
@testable import Grafitti_Backgrounds

extension AppController {
	static func testable(
		preferencesController: PreferencesControllable = MockPreferencesController(),
		workspaceController: WorkspaceControllable = MockWorkspaceController(),
		menuController: MenuControllable = MockMenuController(),
		photoController: PhotoControllable = MockPhotoController(),
		alertController: AlertControlling = MockAlertController(),
		app: Applicationable = MockApplication()) -> AppController {
		return AppController(
			preferencesController: preferencesController,
			workspaceController: workspaceController,
			menuController: menuController,
			photoController: photoController,
			alertController: alertController,
			app: app
		)
	}
}
