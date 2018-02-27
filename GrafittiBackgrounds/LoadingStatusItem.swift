//
//  LoadingStatusItem.swift
//  GrafittiBackgrounds
//
//  Created by Lee Arromba on 03/12/2017.
//  Copyright © 2017 Pink Chicken. All rights reserved.
//

import Cocoa

protocol LoadingStatusItemInterface {
    var statusBar: NSStatusBar { get }
    var item: NSStatusItem { get }
    var menu: MenuInterface? { get set }
    var isLoading: Bool { get set }
    var loadingPercentage: Double { get set }
}

extension LoadingStatusItemInterface {
    var menu: MenuInterface? {
        get {
            return item.menu as? MenuInterface
        }
        set {
            item.menu = menu as? NSMenu
        }
    }
}

class LoadingStatusItem: LoadingStatusItemInterface {
    struct Config {
        let image: NSImage
        let loadingImage: NSImage
        let spinnerColor: NSColor

        init(image: NSImage, loadingImage: NSImage, spinnerColor: NSColor) {
            self.image = image
            self.loadingImage = loadingImage
            self.spinnerColor = spinnerColor

            image.isTemplate = true
            loadingImage.isTemplate = true
        }

        static var sprayCan = Config(image: #imageLiteral(resourceName: "spray-can"), loadingImage: #imageLiteral(resourceName: "download"), spinnerColor: NSColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.8))
    }

    let statusBar: NSStatusBar
    let item: NSStatusItem
    var isLoading: Bool = false {
        didSet {
            if isLoading {
                item.image = config.loadingImage
                item.button?.addSubview(spinner)
                spinner.startAnimation(self)
            } else {
                item.image = config.image
                spinner.removeFromSuperview()
                spinner.stopAnimation(self)
                loadingPercentage = 0
            }
        }
    }
    var loadingPercentage: Double {
        get {
            return spinner.doubleValue
        }
        set {
            spinner.doubleValue = newValue
            spinner.displayIfNeeded()
        }
    }

    private let config: Config
    private lazy var spinner: NSProgressIndicator = {
        let size = item.button?.visibleRect.width ?? 0
        let height: CGFloat = size * 0.17 // 17%
        let spinner = NSProgressIndicator(frame: NSRect(x: 0, y: size-height, width: size, height: height))
//        spinner.isBezeled = false
//        spinner.controlSize = .small
//        spinner.usesThreadedAnimation = true
        spinner.style = .bar
        spinner.wantsLayer = true
        spinner.setCIColor(config.spinnerColor)
        spinner.isIndeterminate = false
        spinner.minValue = 0.0
        spinner.maxValue = 1.0
        spinner.doubleValue = 0.0
        return spinner
    }()
    
    init(config: Config, statusBar: NSStatusBar) {
        self.config = config
        self.statusBar = statusBar
        self.item = statusBar.statusItem(withLength: NSStatusItem.variableLength)
        item.image = config.image
    }

    deinit {
        statusBar.removeStatusItem(item)
    }
}
