//
//  BaseOperation.swift
//  GrafittiBackgrounds
//
//  Created by Lee Arromba on 02/12/2017.
//  Copyright © 2017 Pink Chicken. All rights reserved.
//

import Foundation

class BaseOperation: Operation {
    private enum State {
        case ready, executing, finished
    }
    private enum KVOKey: String {
        case isExecuting, isFinished
    }
    private var _state: State = .ready
    private var state: State {
        get {
            return _state
        }
        set {
            guard _state != newValue else {
                return
            }

            let kvoKey: String
            switch newValue {
            case .ready:
                fatalError("Operations are not reusable")
            case .executing:
                kvoKey = KVOKey.isExecuting.rawValue
            case .finished:
                kvoKey = KVOKey.isFinished.rawValue
            }

            willChangeValue(forKey: kvoKey)
            _state = newValue
            didChangeValue(forKey: kvoKey)
        }
    }

    final override func start() {
        if isCancelled {
            state = .finished
        } else {
            state = .executing
            execute()
        }
    }

    final override var isReady: Bool {
        return state == .ready
    }

    final override var isExecuting: Bool {
        return state == .executing
    }

    final override var isFinished: Bool {
        return state == .finished
    }

    func execute() {
        assertionFailure("super should not be called")
    }

    final func finish() {
        state = .finished
    }
}
