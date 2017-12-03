//
//  StoryboardExtensions.swift
//  GrafittiBackgrounds
//
//  Created by Lee Arromba on 03/12/2017.
//  Copyright © 2017 Pink Chicken. All rights reserved.
//

import Cocoa

extension NSStoryboard {
    static var preferences: NSStoryboard {
        return NSStoryboard(name: NSStoryboard.Name(rawValue: "Preferences"), bundle: nil)
    }
}
