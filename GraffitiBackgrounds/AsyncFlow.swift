import Foundation

// The idea of this is simple. Async callbacks are a real nightmare, sure. However, I tried making a promise
// implmentation based on https://github.com/khanlou/Promise/blob/master/Promise/Promise.swift and whilst cool,
// it makes xcode really slow. It looks neat once it's done, but getting everything in the right place is quite
// a headache. PromiseKit might be better, but in the end, it's another dependency. There's talk of async / await
// being part of swift: https://gist.github.com/lattner/429b9070918248274f25b714dcfc7619 so sticking promises everywhere
// means another refactor at some point. this is an interesting article:
// http://thecodebarbarian.com/2015/03/20/callback-hell-is-a-myth
// and i think it makes a fair point. therefore, this is an attempt at taming callback hell, and to be honest it's super
// simple. i really like it. also, when performing with instruments, this performs way better than with promises.
// whilst it makes the initial implementation method large, it reads like a book.
protocol AsyncFlowContext: AnyObject {
    var callBacks: [() -> Void] { get set }
    var finally: (() -> Void)? { get set }

    func add(callback: @escaping () -> Void)
    func setFinally(_ finally: @escaping () -> Void)
    func start()
    func next()
    func finished()
}

extension AsyncFlowContext {
    var step: Int {
        return callBacks.count
    }

    func add(callback: @escaping () -> Void) {
        callBacks.append(callback)
    }

    func setFinally(_ finally: @escaping () -> Void) {
        self.finally = finally
    }

    func start() {
        callBacks.first?()
        log("\(String(describing: self)) starting callback [0] of \(callBacks.count)")
    }

    func next() {
        guard callBacks.count > 1 else { return }
        _ = callBacks.remove(at: 0)
        callBacks.first?()
        log("\(self) starting callback [0] of \(callBacks.count)")
    }

    func finished() {
        finally?()
        finally = nil
        callBacks.removeAll()
        log("\(self) finished flow")
    }
}
