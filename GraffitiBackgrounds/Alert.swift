import Foundation

struct Alert {
    let title: String
    let text: String
}

extension Alert {
    static func error(_ error: Error) -> Alert {
        return Alert(title: L10n.Alert.GenericError.title, text: error.localizedDescription)
    }

    static var reloadingPhotos: Alert {
        return Alert(title: L10n.Alert.ReloadPhotosStarted.title, text: L10n.Alert.ReloadPhotosStarted.message)
    }

    static var reloadPhotosSuccess: Alert {
        return Alert(title: L10n.Alert.ReloadPhotosFinished.title, text: L10n.Alert.ReloadPhotosFinished.message)
    }

    static var clearFolderSuccess: Alert {
        return Alert(title: L10n.Alert.PhotosCleared.title, text: L10n.Alert.PhotosCleared.message)
    }

    static var cancelReloadSuccess: Alert {
        return Alert(title: "", text: L10n.Alert.ReloadPhotosCancelled.message)
    }
}
