//
//  NSApplicationInterface.swift
//  GrafittiBackgrounds
//
//  Created by Lee Arromba on 12/12/2017.
//  Copyright © 2017 Pink Chicken. All rights reserved.
//

import Cocoa

extension NSApplication: NSApplicationInterface {}

protocol NSApplicationInterface {
    func orderFrontStandardAboutPanel(_ sender: Any?)
    func orderFrontStandardAboutPanel(options optionsDictionary: [NSApplication.AboutPanelOptionKey : Any])
    func terminate(_ sender: Any?)
}
