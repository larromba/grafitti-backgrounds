import Foundation

// sometimes we need to attach the item with any result
struct AnyResult<T> {
    let item: T
    let result: Result<Void>
}
