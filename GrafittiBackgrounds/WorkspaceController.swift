//
//  WorkspaceController.swift
//  GrafittiBackgrounds
//
//  Created by Lee Arromba on 05/12/2017.
//  Copyright © 2017 Pink Chicken. All rights reserved.
//

import Cocoa

// sourcery: name = WorkspaceController
protocol WorkspaceControllable: Mockable {
    var workspace: Workspacing { get }

    func open(_ preference: SystemPreference)
    func open(_ url: URL)
}

final class WorkspaceController: WorkspaceControllable {
    let workspace: Workspacing

    init(workspace: Workspacing) {
        self.workspace = workspace
    }

    func open(_ preference: SystemPreference) {
        _ = workspace.open(preference.url)
    }

    func open(_ url: URL) {
        _ = workspace.open(url)
    }
}
