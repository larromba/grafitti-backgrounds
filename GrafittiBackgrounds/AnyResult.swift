import Foundation

// sometimes we need to attach the item with a result
struct ResultItem<T> {
    let item: T
    let result: Result<Void>
}
