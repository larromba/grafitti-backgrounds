import Foundation

// sourcery: name = PreferencesService
protocol PreferencesServicing: Mockable {
    func save(_ preferences: Preferences) -> Result<Void>
    func load() -> Result<Preferences>
}

final class PreferencesService: PreferencesServicing {
    enum PreferencesError: Error {
        case encodeError(Error)
        case decodeError(Error)
    }
    private enum Key: String, Keyable {
        case preferences
    }

    private let encoder = PropertyListEncoder()
    private let decoder = PropertyListDecoder()
    private let dataManager: DataManaging

    init(dataManager: DataManaging) {
        self.dataManager = dataManager
    }

    func save(_ preferences: Preferences) -> Result<Void> {
        do {
            let data = try encoder.encode(preferences)
            dataManager.save(data, key: Key.preferences)
            return .success(())
        } catch {
            return .failure(PreferencesError.encodeError(error))
        }
    }

    func load() -> Result<Preferences> {
        switch dataManager.load(key: Key.preferences) {
        case .success(let data):
            do {
                let preferences = try decoder.decode(Preferences.self, from: data)
                return .success(preferences)
            } catch {
                return .failure(PreferencesError.decodeError(error))
            }
        case .failure(let error):
            switch error {
            case DataManger.DataError.dataNotFound:
                return .success(Preferences())
            default:
                return .failure(error)
            }
        }
    }
}
