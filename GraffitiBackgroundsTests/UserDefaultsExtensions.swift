import Foundation

extension UserDefaults {
    static var mock: UserDefaults {
        let userDefaults = UserDefaults(suiteName: "test")!
        userDefaults.dictionaryRepresentation().keys.forEach(userDefaults.removeObject(forKey:))
        return userDefaults
    }

    // TODO: need this?
//    func reset() {
//        dictionaryRepresentation().keys.forEach { key in
//            self.removeObject(forKey: key)
//        }
//    }
}
