import Foundation

// sourcery: name = OperationQueue
protocol OperationQueable: Mockable {
    //swiftlint:disable identifier_name
    func addOperation(_ op: Operation)
    func cancelAllOperations()
}
extension OperationQueue: OperationQueable {}
