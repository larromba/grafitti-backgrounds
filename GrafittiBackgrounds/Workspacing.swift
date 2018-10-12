//
//  Workspacing.swift
//  GrafittiBackgrounds
//
//  Created by Lee Arromba on 10/12/2017.
//  Copyright © 2017 Pink Chicken. All rights reserved.
//

import Cocoa

// sourcery: name = Workspace
protocol Workspacing: Mockable {
	// sourcery: returnValue = true
    func open(_ url: URL) -> Bool
}
extension NSWorkspace: Workspacing {}
