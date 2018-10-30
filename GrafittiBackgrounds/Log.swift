import Foundation

func log(_ msg: String) {
    #if DEBUG
        print(msg)
    #endif
}
