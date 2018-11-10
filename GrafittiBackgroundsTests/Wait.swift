import Foundation
import XCTest

// see https://stackoverflow.com/questions/31182637/delay-wait-in-a-test-case-of-xcode-ui-testing
extension XCTestCase {
    func wait(for duration: TimeInterval, completion: (() -> Void)?) {
        let waitExpectation = expectation(description: "Waiting")
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            waitExpectation.fulfill()
            completion?()
        }
        waitForExpectations(timeout: duration)
    }
}
