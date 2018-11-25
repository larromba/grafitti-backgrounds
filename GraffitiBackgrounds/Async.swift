// modified from "freshOS/then" https://github.com/freshOS/then/tree/master/Source

import Foundation
import Result

func async(_ callback: @escaping () throws -> Void, onError: @escaping (Error) -> Void) {
    DispatchQueue(label: "async.queue", attributes: .concurrent).async {
        do {
            try callback()
        } catch {
            onError(error)
        }
    }
}

struct Async<T> {
    typealias Completion = (Result<T>) -> Void

    let completion: (@escaping Completion) -> Void

    init(_ completion: @escaping (@escaping Completion) -> Void) {
        self.completion = completion
    }
}

func onMain(callback: @escaping () -> Void) {
    DispatchQueue.main.async {
        callback()
    }
}
