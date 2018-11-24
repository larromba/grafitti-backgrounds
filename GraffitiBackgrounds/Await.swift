// modified from on "freshOS/then" async / await implementation https://github.com/freshOS/then/tree/master/Source

import Foundation

@discardableResult
func await<T>(_ operation: Async<T>) throws -> T {
    var value: T!
    var error: Error?
    let group = DispatchGroup()

    group.enter()
    operation.completion { result in
        switch result {
        case .success(let resultValue):
            value = resultValue
            group.leave()
        case .failure(let resultError):
            error = resultError
            group.leave()
        }
    }
    group.wait()

    if let error = error { throw error }
    return value
}

@discardableResult
func awaitAll<T>(_ operations: [Async<T>],
                 bailEarly: Bool = false,
                 progress: ((Double) -> Void)? = nil) throws -> ([T], [Error]) {
    var values = [T]()
    var errors = [Error]()
    let group = DispatchGroup()
    var isBailed = false

    for operation in operations {
        group.enter()
        operation.completion { result in
            guard !isBailed else { return }
            switch result {
            case .success(let resultValue):
                values += [resultValue]
                group.leave()
            case .failure(let resultError):
                errors += [resultError]
                guard !bailEarly else {
                    isBailed = true
                    (values.count..<operations.count).forEach { _ in group.leave() }
                    return
                }
                group.leave()
            }
            progress?(Double(values.count + errors.count) / Double(operations.count))
        }
    }
    group.wait()

    guard !isBailed else { throw errors[0] }
    return (values, errors)
}
