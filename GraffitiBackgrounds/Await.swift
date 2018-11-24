// modifid from on "freshOS/then" async / await implementation https://github.com/freshOS/then/tree/master/Source

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

    if let error = error {
        throw error
    }
    return value
}

@discardableResult
func awaitAll<T>(_ operations: [Async<T>],
                 bailEarly: Bool = false,
                 progress: ((Double) -> Void)? = nil) throws -> ([T], [Error]) {
    var values = [T]()
    var errors = [Error]()
    let group = DispatchGroup()

    operations.forEach { operation in
        group.enter()
        operation.completion { result in
            switch result {
            case .success(let resultValue):
                values.append(resultValue)
                group.leave()
            case .failure(let resultError):
                errors.append(resultError)
                if bailEarly {
                    (values.count..<operations.count).forEach { _ in group.leave() }
                } else {
                    group.leave()
                }
            }
            progress?(Double(values.count + errors.count) / Double(operations.count))
        }
    }
    group.wait()

    if bailEarly {
        throw errors[0]
    }
    return (values, errors)
}
