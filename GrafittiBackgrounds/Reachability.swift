//swiftlint:disable file_header
//
//  Reachability.swift
//  Etcetera
//
//  Copyright © 2018 Nice Boy LLC. All rights reserved.
//

import Foundation
import SystemConfiguration

protocol Reachable {
    var isReachable: Bool { get }

    func setDelegate(_ delegate: ReachabilityDelegate)
}

protocol ReachabilityDelegate: AnyObject {
    func reachabilityDidChange(_ reachability: Reachable, isReachable: Bool)
}

/// A class that reports whether or not the network is currently reachable.
final class Reachability: NSObject, Reachable {

    /// Synchronous evaluation of the current flags.
    var isReachable: Bool {
        return flags?.contains(.reachable) == true
    }

    private let reachability: SCNetworkReachability?
    private weak var delegate: ReachabilityDelegate?
    private var lock = os_unfair_lock()
    private var _flags: SCNetworkReachabilityFlags?
    private var flags: SCNetworkReachabilityFlags? {
        get {
            os_unfair_lock_lock(&lock)
            let value = _flags
            os_unfair_lock_unlock(&lock)
            return value
        }
        set {
            os_unfair_lock_lock(&lock)
            _flags = newValue
            os_unfair_lock_unlock(&lock)
            delegate?.reachabilityDidChange(self, isReachable: isReachable)
        }
    }

    init(host: String = "www.google.com") {
        self.reachability = SCNetworkReachabilityCreateWithName(nil, host)
        super.init()
        guard let reachability = reachability else { return }

        // Populate the current flags asap.
        var flags = SCNetworkReachabilityFlags()
        SCNetworkReachabilityGetFlags(reachability, &flags)
        _flags = flags

        // Then configure the callback.
        let callback: SCNetworkReachabilityCallBack = { _, flags, infoPtr in
            guard let info = infoPtr else { return }
            let this = Unmanaged<Reachability>.fromOpaque(info).takeUnretainedValue()
            this.flags = flags
        }
        let selfPtr = Unmanaged.passUnretained(self).toOpaque()
        var context = SCNetworkReachabilityContext(
            version: 0, info: selfPtr, retain: nil, release: nil, copyDescription: nil
        )
        SCNetworkReachabilitySetCallback(reachability, callback, &context)
        SCNetworkReachabilitySetDispatchQueue(reachability, .main)
    }

    func setDelegate(_ delegate: ReachabilityDelegate) {
        self.delegate = delegate
    }
}
