//
//  ConcurrentOperation.swift
//  GooglePhotosBackground
//
//  Created by Lee Arromba on 02/12/2017.
//  Copyright © 2017 Pink Chicken. All rights reserved.
//

import Foundation

class ConcurrentOperation: Operation {
    private enum State {
        case ready, executing, finished
    }
    private enum KVOKey: String {
        case isExecuting, isFinished
    }

    private let lock = NSLock()
    private var _state: State = .ready

    private var state: State {
        get {
            let current: State
            lock.lock()
            current = _state
            lock.unlock()
            return current
        }
        set {
            lock.lock()
            guard _state != newValue else {
                return
            }
            lock.unlock()

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
            lock.lock()
            _state = newValue
            lock.unlock()
            didChangeValue(forKey: kvoKey)
        }
    }

    // MARK: Overides

    final override func start() {
        if isCancelled {
            state = .finished
        } else {
            state = .executing
            execute()
        }
    }

    final override var isConcurrent: Bool {
        return true
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
