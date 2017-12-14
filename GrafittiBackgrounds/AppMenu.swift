//
//  AppMenu.swift
//  GrafittiBackgrounds
//
//  Created by Lee Arromba on 08/12/2017.
//  Copyright © 2017 Pink Chicken. All rights reserved.
//

import Foundation

enum AppMenu {
    enum Action {
        case refreshFolder
        case cancelRefresh
        case openFolder
        case clearFolder
        case preferences
        case systemPreferences
        case about
        case quit
    }
    enum RefreshAction {
        case cancel
        case refresh
    }
}
