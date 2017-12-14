//
//  WorkspaceCoordinator.swift
//  GrafittiBackgrounds
//
//  Created by Lee Arromba on 05/12/2017.
//  Copyright © 2017 Pink Chicken. All rights reserved.
//

import Cocoa

protocol WorkspaceCoordinatorInterface {
    var workspace: NSWorkspaceInterface { get }

    func open(_ preference: SystemPreference)
    func open(_ url: URL)
}

class WorkspaceCoordinator: WorkspaceCoordinatorInterface {
    let workspace: NSWorkspaceInterface

    init(workspace: NSWorkspaceInterface) {
        self.workspace = workspace
    }

    func open(_ preference: SystemPreference) {
        _ = workspace.open(preference.url)
    }

    func open(_ url: URL) {
        _ = workspace.open(url)
    }
}
