import Foundation

// sourcery: name = DataManger
protocol DataManaging: Mockable {
    func save<T: Keyable>(_ data: Data?, key: T)
    // sourcery: returnValue = Result.success(Data())
    func load<T: Keyable>(key: T) -> Data?
}

final class DataManger: DataManaging {
    private let userDefaults: UserDefaultable

    init(userDefaults: UserDefaultable) {
        self.userDefaults = userDefaults
    }

    func save<T: Keyable>(_ data: Data?, key: T) {
        userDefaults.set(data, forKey: key.rawValue)
    }

    func load<T: Keyable>(key: T) -> Data? {
        return userDefaults.object(forKey: key.rawValue) as? Data
    }
}
