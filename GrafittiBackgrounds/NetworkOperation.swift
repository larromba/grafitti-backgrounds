//
//  NetworkOperation.swift
//  GrafittiBackgrounds
//
//  Created by Lee Arromba on 03/12/2017.
//  Copyright © 2017 Pink Chicken. All rights reserved.
//

import Cocoa

class NetworkOperation: BaseOperation {
    var task: URLSessionTask?

    override var isConcurrent: Bool {
        return true
    }

    override func execute() {
        task?.resume()
    }

    override func cancel() {
        task?.cancel()
        super.cancel()
    }
}
