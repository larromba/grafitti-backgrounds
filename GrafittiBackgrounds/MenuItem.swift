//
//  MenuItem.swift
//  GrafittiBackgrounds
//
//  Created by Lee Arromba on 03/12/2017.
//  Copyright © 2017 Pink Chicken. All rights reserved.
//

import Cocoa

protocol MenuItemInterface {
	var delegate: MenuItemDelegate? { get }
	var viewModel: MenuItemViewModel { get }
}

protocol MenuItemDelegate: class {
	func menuItemPressed(_ menuItem: MenuItemInterface)
}

class MenuItem: NSMenuItem, MenuItemInterface {
	weak var delegate: MenuItemDelegate?
	var viewModel: MenuItemViewModel {
		didSet {
			refresh(viewModel: viewModel)
		}
	}

	init(viewModel: MenuItemViewModel, delegate: MenuItemDelegate) {
		self.delegate = delegate
		self.viewModel = viewModel
        super.init(title: viewModel.title, action: #selector(action(_:)), keyEquivalent: viewModel.keyEquivalent)
        self.target = self
    }

    required init(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - private

    @objc private func action(_ sender: NSMenuItem) {
        delegate?.menuItemPressed(self)
    }

	private func refresh(viewModel: MenuItemViewModel) {
		self.title = viewModel.title
		self.keyEquivalent = viewModel.keyEquivalent
		self.isEnabled = viewModel.isEnabled
	}
}
