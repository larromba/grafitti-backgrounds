//
//  MenuItem.swift
//  GooglePhotosBackground
//
//  Created by Lee Arromba on 03/12/2017.
//  Copyright © 2017 Pink Chicken. All rights reserved.
//

import Cocoa

class MenuItem: NSMenuItem {
    var actionBlock: (() -> Void)?

    init(title: String, actionBlock: (() -> Void)?, keyEquivalent: String = "", isEnabled: Bool = true) {
        self.actionBlock = actionBlock
        super.init(title: title, action: #selector(action(_:)), keyEquivalent: keyEquivalent)
        self.isEnabled = isEnabled
        self.target = self
    }

    required init(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - private

    @objc private func action(_ sender: NSMenuItem) {
        actionBlock?()
    }
}
