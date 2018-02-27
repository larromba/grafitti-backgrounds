//
//  GrafittiBackgroundsTests.swift
//  GrafittiBackgroundsTests
//
//  Created by Lee Arromba on 14/12/2017.
//  Copyright © 2017 Pink Chicken. All rights reserved.
//

import XCTest
@testable import Grafitti_Backgrounds

class AppCoordintorTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testPreferences() {
        // mocks
        class MockWindowController: StubWindowController {
            var didShowWindow = false
            override func showWindow(_ sender: Any?) {
                didShowWindow = true
            }
        }
        let statusItem = StubLoadingStatusItem()
        let menuCoordinator = MenuCoordinator(statusItem: statusItem)
        let windowController = MockWindowController(viewController: StubPreferencesViewController())
        let preferencesCoordinator = PreferencesCoordinator(windowController: windowController, preferencesService: StubPreferencesService(), preferencesDataSource: PreferencesDataSource())
        _ = AppCoordinator(preferencesCoordinator: preferencesCoordinator, workspaceCoordinator: StubWorkspaceCoordinator(), menuCoordinator: menuCoordinator, photoCoordinator: StubPhotoCoordinator(), app: StubApplication())

        // test
        statusItem.menu?.item(at: 4)?.actionBlock()
        XCTAssertTrue(windowController.didShowWindow)
    }

    func testSystemPreferences() {
        // mocks
        class MockWorkspaceCoordinator: StubWorkspaceCoordinator {
            var preference: SystemPreference!
            var didOpenSystemPreferences = false
            override func open(_ preference: SystemPreference) {
                didOpenSystemPreferences = self.preference == preference
            }
        }
        let statusItem = StubLoadingStatusItem()
        let menuCoordinator = MenuCoordinator(statusItem: statusItem)
        let workspaceCoordinator = MockWorkspaceCoordinator()
        _ = AppCoordinator(preferencesCoordinator: StubPreferencesCoordinator(), workspaceCoordinator: workspaceCoordinator, menuCoordinator: menuCoordinator, photoCoordinator: StubPhotoCoordinator(), app: StubApplication())

        // prepare
        workspaceCoordinator.preference = .desktopScreenEffects

        // test
        statusItem.menu?.item(at: 5)?.actionBlock()
        XCTAssertTrue(workspaceCoordinator.didOpenSystemPreferences)
    }
    
    func testAbout() {
        // mocks
        class MockApplication: StubApplication {
            var didShowAbout = false
            override func orderFrontStandardAboutPanel(_ sender: Any?) {
                didShowAbout = true
            }
        }
        let statusItem = StubLoadingStatusItem()
        let menuCoordinator = MenuCoordinator(statusItem: statusItem)
        let app = MockApplication()
        _ = AppCoordinator(preferencesCoordinator: StubPreferencesCoordinator(), workspaceCoordinator: StubWorkspaceCoordinator(), menuCoordinator: menuCoordinator, photoCoordinator: StubPhotoCoordinator(), app: app)

        // test
        statusItem.menu?.item(at: 7)?.actionBlock()
        XCTAssertTrue(app.didShowAbout)
    }

    func testQuit() {
        // mocks
        class MockApplication: StubApplication {
            var didTerminate = false
            override func terminate(_ sender: Any?) {
                didTerminate = true
            }
        }
        let statusItem = StubLoadingStatusItem()
        let menuCoordinator = MenuCoordinator(statusItem: statusItem)
        let app = MockApplication()
        _ = AppCoordinator(preferencesCoordinator: StubPreferencesCoordinator(), workspaceCoordinator: StubWorkspaceCoordinator(), menuCoordinator: menuCoordinator, photoCoordinator: StubPhotoCoordinator(), app: app)

        // test
        statusItem.menu?.item(at: 8)?.actionBlock()
        XCTAssertTrue(app.didTerminate)
    }
}
