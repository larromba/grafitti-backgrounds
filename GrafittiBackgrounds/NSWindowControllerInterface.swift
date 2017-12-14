//
//  NSWindowControllerInterface.swift
//  GrafittiBackgrounds
//
//  Created by Lee Arromba on 14/12/2017.
//  Copyright © 2017 Pink Chicken. All rights reserved.
//

import Cocoa

extension NSWindowController: NSWindowControllerInterface {}

protocol NSWindowControllerInterface {
    var contentViewController: NSViewController? { get set }

    func showWindow(_ sender: Any?)
}
