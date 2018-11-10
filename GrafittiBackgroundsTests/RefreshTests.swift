@testable import Grafitti_Backgrounds
import XCTest

class RefreshTests: XCTestCase {
	func testRefreshFolderOnMenuClickChangesMenuAndIconState() {
        // mocks
        let viewState = LoadingStatusItemViewState(isLoading: false, loadingPercentage: 0, style: .sprayCan, alpha: 1.0)
        let statusItem = LoadingStatusItem(viewState: viewState, statusBar: .system)
        let menuController = AppMenuController(statusItem: statusItem, reachability: MockReachability())
        menuController.setRefreshAction(.refresh)
        let photoController = PhotoController.testable()

        // sut
        _ = AppController.testable(menuController: menuController, photoController: photoController)

        // test
        guard let menu = statusItem.menu, menu.click(at: AppMenu.Order.refreshFolder.rawValue) else {
            XCTFail("expected menu to click")
            return
        }
        XCTAssertEqual(menu.viewState.items[safe: AppMenu.Order.refreshFolder.rawValue]?.title, "Cancel Refresh")
        XCTAssertEqual(menu.viewState.items[safe: AppMenu.Order.clearFolder.rawValue]?.isEnabled, false)
        XCTAssertEqual(statusItem.isLoading, true)
        XCTAssertEqual(statusItem.item.button?.alphaValue, 1.0)
        XCTAssertEqual(statusItem.item.button?.subviews
            .contains(where: { $0.classForCoder == NSProgressIndicator.self }), true)
        XCTAssertEqual(statusItem.item.image, statusItem.viewState.style.loadingImage)
	}

	func testRefreshFolderOnMenuClickClearsAndDownloadsNewPhotos() {
//        // mocks
//        let menuController = AppMenuController(statusItem: MockLoadingStatusItem(), reachability: MockReachability())
//        let photoController = PhotoController.testable()
//
//        // sut
//        _ = AppController.testable(menuController: menuController, photoController: photoController)
//
//        // test
//        guard let menu = statusItem.menu, menu.click(at: AppMenu.Order.refreshFolder.rawValue) else {
//            XCTFail("expected menu to click")
//            return
//        }

	}

    func testLoadingIndicatorIncrementsUponDownload() {
        // mocks
        let viewState = LoadingStatusItemViewState(isLoading: false, loadingPercentage: 0, style: .sprayCan, alpha: 1.0)
        let statusItem = LoadingStatusItem(viewState: viewState, statusBar: .system)
        let menuController = AppMenuController(statusItem: statusItem, reachability: MockReachability())

        // sut
        _ = AppController.testable(menuController: menuController)

        // test
        menuController.setIsLoading(true)
        menuController.setLoadingPercentage(0.3)

        let views = statusItem.item.button?.subviews.filter { $0.classForCoder == NSProgressIndicator.self }
        guard let progressIndicator = views?.first as? NSProgressIndicator else {
            XCTFail("expected NSProgressIndicator")
            return
        }
        XCTAssertEqual(progressIndicator.doubleValue, 0.3)
    }
}
