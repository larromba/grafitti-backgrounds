//
//  LoadingStatusItemViewModel.swift
//  GrafittiBackgrounds
//
//  Created by Lee Arromba on 04/08/2018.
//  Copyright © 2018 Pink Chicken. All rights reserved.
//

import Cocoa

struct LoadingStatusItemViewModel {
	struct Style {
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

		static var sprayCan = Style(
			image: #imageLiteral(resourceName: "spray-can"),
			loadingImage: #imageLiteral(resourceName: "download"),
			spinnerColor: NSColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.8)
		)
	}
	
	let isLoading: Bool
	let loadingPercentage: Double
	let style: Style
}
