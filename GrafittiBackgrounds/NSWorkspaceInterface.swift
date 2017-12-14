//
//  NSWorkspaceInterface.swift
//  GrafittiBackgrounds
//
//  Created by Lee Arromba on 10/12/2017.
//  Copyright © 2017 Pink Chicken. All rights reserved.
//

import Cocoa

extension NSWorkspace: NSWorkspaceInterface {}

protocol NSWorkspaceInterface {
    func open(_ url: URL) -> Bool
}
