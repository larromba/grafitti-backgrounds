//
//  WorkspaceCoordinator.swift
//  GrafittiBackgrounds
//
//  Created by Lee Arromba on 05/12/2017.
//  Copyright © 2017 Pink Chicken. All rights reserved.
//

import Cocoa

class WorkspaceCoordinator {
    private let workspace = NSWorkspace.shared

    func open(_ preference: SystemPreference) {
        workspace.open(preference.url)
    }

    func open(_ url: URL) {
        workspace.open(url)
    }
}
