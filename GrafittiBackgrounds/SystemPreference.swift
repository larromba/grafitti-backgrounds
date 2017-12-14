//
//  SystemPreference.swift
//  GrafittiBackgrounds
//
//  Created by Lee Arromba on 08/12/2017.
//  Copyright © 2017 Pink Chicken. All rights reserved.
//

import Foundation

enum SystemPreference {
    case desktopScreenEffects

    var url: URL {
        switch self {
        case .desktopScreenEffects:
            return URL(fileURLWithPath: "/System/Library/PreferencePanes/DesktopScreenEffectsPref.prefPane")
        }
    }
}
