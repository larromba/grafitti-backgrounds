import Foundation
import Result

// sourcery: name = PreferencesService
protocol PreferencesServicing: Mockable {
    // sourcery: returnValue = Result.success(())
    func save(_ preferences: Preferences) -> Result<Void>
    // sourcery: returnValue = Result.success(Preferences())
    func load() -> Result<Preferences>
}

final class PreferencesService: PreferencesServicing {
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
        guard let data = dataManager.load(key: Key.preferences) else {
            return .success(Preferences())
        }
        do {
            let preferences = try decoder.decode(Preferences.self, from: data)
            return .success(preferences)
        } catch {
            return .failure(PreferencesError.decodeError(error))
        }
    }
}
