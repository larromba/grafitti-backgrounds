//
//  FileManaging.swift
//  GrafittiBackgrounds
//
//  Created by Lee Arromba on 14/12/2017.
//  Copyright © 2017 Pink Chicken. All rights reserved.
//

import Cocoa

// sourcery: name = FileManager
protocol FileManaging: Mockable {
    func removeItem(at URL: URL) throws
    func moveItem(at srcURL: URL, to dstURL: URL) throws
    func createDirectory(at url: URL, withIntermediateDirectories createIntermediates: Bool, attributes: [FileAttributeKey : Any]?) throws
	// sourcery: returnValue = true
    func fileExists(atPath path: String) -> Bool
}
extension FileManager: FileManaging {}
