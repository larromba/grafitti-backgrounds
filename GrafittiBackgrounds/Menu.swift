//
//  Menu.swift
//  GrafittiBackgrounds
//
//  Created by Lee Arromba on 03/12/2017.
//  Copyright © 2017 Pink Chicken. All rights reserved.
//

import Cocoa

class Menu: NSMenu {
    init(title: String, items: [NSMenuItem]) {
        super.init(title: title)
        autoenablesItems = false
        items.forEach({ addItem($0) })
    }

    required init(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NSMenu {
    func item(at index: Int) -> NSMenuItem? {
        guard index >= items.startIndex, index < items.endIndex else {
            return nil
        }
        return items[index]
    }
}
