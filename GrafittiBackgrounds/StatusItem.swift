//
//  StatusItem.swift
//  GrafittiBackgrounds
//
//  Created by Lee Arromba on 03/12/2017.
//  Copyright © 2017 Pink Chicken. All rights reserved.
//

import Cocoa

class StatusItem {
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
    }

    let item = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
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
    
    init(config: Config) {
        self.config = config
        item.image = config.image
    }

    deinit {
        NSStatusBar.system.removeStatusItem(item)
    }
}
