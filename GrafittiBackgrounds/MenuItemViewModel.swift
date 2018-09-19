//
//  MenuItemViewModel.swift
//  GrafittiBackgrounds
//
//  Created by Lee Arromba on 19/07/2018.
//  Copyright © 2018 Pink Chicken. All rights reserved.
//

import Foundation

struct MenuItemViewModel {
	let title: String
	let keyEquivalent: String
	let isEnabled: Bool
	let menuAction: MenuAction?
}

extension MenuItemViewModel {
	init(title: String, action: MenuAction?) {
		self.title = title
		keyEquivalent = ""
		isEnabled = true
		menuAction = action
	}
}
