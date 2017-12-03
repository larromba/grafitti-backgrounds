//
//  Main.swift
//  GooglePhotosBackground
//
//  Created by Lee Arromba on 03/12/2017.
//  Copyright © 2017 Pink Chicken. All rights reserved.
//

import Cocoa
import Foundation

private func main() {
    let app = NSApplication.shared
    NSApp = app

    let appDelegate = AppDelegate()
    app.delegate = appDelegate

    _ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
}

main()
