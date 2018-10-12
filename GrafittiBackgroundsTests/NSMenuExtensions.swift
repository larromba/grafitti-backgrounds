//
//  GrafittiBackgroundsTests.swift
//  GrafittiBackgroundsTests
//
//  Created by Lee Arromba on 16/09/2018.
//  Copyright © 2017 Pink Chicken. All rights reserved.
//

import Cocoa
@testable import Grafitti_Backgrounds

extension Menuable {
	func click(at index: Int) -> Bool {
		guard let menuItem = item(at: index) as? MenuItem else {
			return false
		}
		return menuItem.click()
	}
}

extension NSMenuItem {
	func click() -> Bool {
		guard let action = action else {
			return false
		}
		return NSApp.sendAction(action, to: target, from: nil)
	}
}
