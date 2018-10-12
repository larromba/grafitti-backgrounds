//
//  LoadingStatusItem.swift
//  GrafittiBackgrounds
//
//  Created by Lee Arromba on 03/12/2017.
//  Copyright © 2017 Pink Chicken. All rights reserved.
//

import Cocoa

// sourcery: name = LoadingStatusItem
protocol LoadingStatusItemable: Mockable {
    var statusBar: NSStatusBar { get }
    var item: NSStatusItem { get }
    var isLoading: Bool { get }
    var loadingPercentage: Double { get }
	var viewModel: LoadingStatusItemViewModel { get set }
}

extension LoadingStatusItemable {
    var menu: Menuable? {
        get {
            return item.menu as? Menuable
        }
        set {
            item.menu = menu as? NSMenu
        }
    }
}

final class LoadingStatusItem: LoadingStatusItemable {
    let statusBar: NSStatusBar
    let item: NSStatusItem
	var viewModel: LoadingStatusItemViewModel {
		didSet {
			update(viewModel: viewModel)
		}
	}
    private(set) var isLoading: Bool = false {
        didSet {
            if isLoading {
                item.image = viewModel.style.loadingImage
                item.button?.addSubview(spinner)
                spinner.startAnimation(self)
            } else {
                item.image = viewModel.style.image
                spinner.removeFromSuperview()
                spinner.stopAnimation(self)
                loadingPercentage = 0
            }
        }
    }
    private(set) var loadingPercentage: Double {
        get {
            return spinner.doubleValue
        }
        set {
            spinner.doubleValue = newValue
            spinner.displayIfNeeded()
        }
    }
    private lazy var spinner: NSProgressIndicator = {
        let size = item.button?.visibleRect.width ?? 0
        let height: CGFloat = size * 0.17 // 17%
        let spinner = NSProgressIndicator(frame: NSRect(x: 0, y: size-height, width: size, height: height))
//        spinner.isBezeled = false
//        spinner.controlSize = .small
//        spinner.usesThreadedAnimation = true
        spinner.style = .bar
        spinner.wantsLayer = true
        spinner.setCIColor(viewModel.style.spinnerColor)
        spinner.isIndeterminate = false
        spinner.minValue = 0.0
        spinner.maxValue = 1.0
        spinner.doubleValue = 0.0
        return spinner
    }()
    
    init(viewModel: LoadingStatusItemViewModel, statusBar: NSStatusBar) {
		self.viewModel = viewModel
        self.statusBar = statusBar
        self.item = statusBar.statusItem(withLength: NSStatusItem.variableLength)
        item.image = viewModel.style.image
    }

    deinit {
        statusBar.removeStatusItem(item)
    }

	// MARK: - private

	private func update(viewModel: LoadingStatusItemViewModel) {
		isLoading = viewModel.isLoading
		loadingPercentage = viewModel.loadingPercentage
	}
}
