//
//  AppDelegate.swift
//  GrafittiBackgrounds
//
//  Created by Lee Arromba on 02/12/2017.
//  Copyright © 2017 Pink Chicken. All rights reserved.
//

import Cocoa

// sourcery: name = AppDelegate
protocol AppDelegatable: NSApplicationDelegate, Mockable {
    var appController: AppControllable { get }
}

final class AppDelegate: NSObject, AppDelegatable {
    let appController: AppControllable

    init(appController: AppControllable) {
        self.appController = appController
        super.init()
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
		guard ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] == nil else {
			return
		}
        appController.start()
    }
}
