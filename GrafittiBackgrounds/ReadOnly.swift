//
//  ReadOnlyTextField.swift
//  GrafittiBackgrounds
//
//  Created by Lee Arromba on 10/10/2018.
//  Copyright © 2018 Pink Chicken. All rights reserved.
//

import Cocoa

protocol ReadOnlyTextField {
	var stringValue: String { get }
}
extension NSTextField: ReadOnlyTextField {}

protocol ReadOnlyButton {
	var state: NSControl.StateValue { get }
}
extension NSButton: ReadOnlyButton {}
