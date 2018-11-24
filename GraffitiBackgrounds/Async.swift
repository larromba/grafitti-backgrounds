// modifid from on "freshOS/then" async / await implementation https://github.com/freshOS/then/tree/master/Source

import Foundation

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
