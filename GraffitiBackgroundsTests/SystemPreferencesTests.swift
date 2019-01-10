@testable import Graffiti_Backgrounds
import Reachability
import XCTest

final class SystemPreferencesTests: XCTestCase {
    private var workspace: MockWorkspace!
    private var env: AppTestEnvironment!

    override func setUp() {
        super.setUp()
        workspace = MockWorkspace()
        env = AppTestEnvironment(workspace: workspace)
    }

    override func tearDown() {
        workspace = nil
        env = nil
        super.tearDown()
    }

    func testSystemPreferencesOnMenuClickOpensSystemPreferences() {
        // mocks
        env.inject()

        // sut
        env.statusItem.menu?.click(at: AppMenu.Order.systemPreferences.rawValue)

        // test
        let url = workspace.invocations.find(MockWorkspace.open1.name).first?
            .parameter(for: MockWorkspace.open1.params.url) as? URL
        XCTAssertEqual(url, SystemPreference.desktopScreenEffects.url)
    }
}
