import Foundation

// sourcery: name = DataManger
protocol DataManaging: Mockable {
    func save<T: Keyable>(_ data: Data?, key: T)
    // sourcery: returnValue = Result.success(Data())
    func load<T: Keyable>(key: T) -> Result<Data>
}

final class DataManger: DataManaging {
    private let database: UserDefaultable

    init(database: UserDefaultable) {
        self.database = database
    }

    func save<T: Keyable>(_ data: Data?, key: T) {
        database.set(data, forKey: key.rawValue)
    }

    func load<T: Keyable>(key: T) -> Result<Data> {
        guard let data = database.object(forKey: key.rawValue) as? Data else {
            return .failure(DataError.dataNotFound)
        }
        return .success(data)
    }
}