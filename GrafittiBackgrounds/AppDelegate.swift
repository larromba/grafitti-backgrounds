//
//  AppDelegate.swift
//  GrafittiBackgrounds
//
//  Created by Lee Arromba on 02/12/2017.
//  Copyright © 2017 Pink Chicken. All rights reserved.
//

import Cocoa

protocol AppDelegateInterface: NSApplicationDelegate {
    var appCoordinator: AppCoordinatorInterface { get }
}

class AppDelegate: NSObject, AppDelegateInterface {
    let appCoordinator: AppCoordinatorInterface

    init(appCoordinator: AppCoordinatorInterface) {
        self.appCoordinator = appCoordinator
        super.init()
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
		guard ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] == nil else {
			return
		}
        appCoordinator.start()
    }
}
