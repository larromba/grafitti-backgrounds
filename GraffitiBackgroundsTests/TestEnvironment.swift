import Foundation
@testable import Graffiti_Backgrounds

protocol TestEnvironment: AnyObject {
    var appController: AppController? { get }

    func inject()
}
