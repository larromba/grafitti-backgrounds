@testable import Graffiti_Backgrounds
import Reachability
import XCTest

final class SystemPreferencesTests: XCTestCase {
    func testSystemPreferencesOnMenuClickOpensSystemPreferences() {
        // mocks
        let workspace = MockWorkspace()
        let env = AppControllerEnvironment(workspace: workspace)
        env.inject()

        // sut
        env.statusItem.menu?.click(at: AppMenu.Order.systemPreferences.rawValue)

        // test
        let url = workspace.invocations.find(MockWorkspace.open1.name).first?
            .parameter(for: MockWorkspace.open1.params.url) as? URL
        XCTAssertEqual(url, SystemPreference.desktopScreenEffects.url)
    }
}
