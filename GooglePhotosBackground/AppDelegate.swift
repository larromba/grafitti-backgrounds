//
//  AppDelegate.swift
//  GooglePhotosBackground
//
//  Created by Lee Arromba on 02/12/2017.
//  Copyright © 2017 Pink Chicken. All rights reserved.
//

// TODO: this https://nsrover.wordpress.com/2014/10/10/creating-a-os-x-menubar-only-app/

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    private let app = App()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        app.applicationDidFinishLaunching(aNotification)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}
