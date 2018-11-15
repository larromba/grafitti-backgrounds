import Foundation
@testable import Grafitti_Backgrounds

protocol TestEnvironment: AnyObject {
    var appController: AppController? { get }

    func inject()
}
