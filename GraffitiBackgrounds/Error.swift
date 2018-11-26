import Foundation

private let fallbackMessage = L10n.Alert.Foobar.message

enum PhotoResourceResponseError: LocalizedError {
    case malformedHTML
    case missingBaseURL
    case malformedBaseURL
    case missingPhotoURLs

    var errorDescription: String? {
        return L10n.Alert.NetworkError.message
    }
}

enum PhotoAlbumsResponseError: LocalizedError {
    case malformedHTML
    case noPhotoAlbumsFound

    var errorDescription: String? {
        return L10n.Alert.NetworkError.message
    }
}

enum PhotoResponseError: LocalizedError {
    case malformedHTML
    case missingImageURL
    case malformedImageURL

    var errorDescription: String? {
        return L10n.Alert.NetworkError.message
    }
}

enum PhotoError: LocalizedError {
    case downloadInProgress
    case notEnoughImagesAvailable
    case notEnoughImagesDownloaded
    case fileDeleteError([PhotoResource])

    var errorDescription: String? {
        switch self {
        case .downloadInProgress:
            return fallbackMessage
        case .notEnoughImagesAvailable:
            return L10n.Alert.NotEnoughImagesToDownload.message
        case .notEnoughImagesDownloaded:
            return L10n.Alert.NotEnoughImagesDownloaded.message
        case .fileDeleteError:
            return L10n.Alert.DeletePhotosError.message
        }
    }
}

enum PhotoStorageError: LocalizedError {
    case encodeError(Error)
    case decodeError(Error)
    case fileDeleteError(Error)

    var errorDescription: String? {
        switch self {
        case .encodeError, .decodeError:
            return L10n.Alert.SavePhotoRecordError.message
        case .fileDeleteError:
            return L10n.Alert.DeletePhotosError.message
        }
    }
}

enum PhotoServiceError: LocalizedError {
    case resourceMissingFileURL
    case cantCreateDownloadFolder(Error)
    case moveError(Error)
    case someImagesMissingAfterMove

    var errorDescription: String? {
        switch self {
        case .cantCreateDownloadFolder:
            return L10n.Alert.CreatingDownloadFolderError.message
        case .resourceMissingFileURL, .moveError:
            return fallbackMessage
        case .someImagesMissingAfterMove:
            return L10n.Alert.SomeImagesMissingAfterDownload.message
        }
    }
}

enum WorkspaceError: LocalizedError {
    case errorOpeningURL

    var errorDescription: String? {
        switch self {
        case .errorOpeningURL:
            return L10n.Alert.OpeningFolderError.message
        }
    }
}

enum PreferencesError: LocalizedError {
    case encodeError(Error)
    case decodeError(Error)

    var errorDescription: String? {
        switch self {
        case .encodeError:
            return L10n.Alert.WritingPreferencesError.message
        case .decodeError:
            return L10n.Alert.ReadingPreferencesError.message
        }
    }
}

enum NetworkError: LocalizedError {
    case noData
    case systemError(Error)
    case httpErrorCode(Int)
    case badResponse(Error)
    case cancelled

    var errorDescription: String? {
        return L10n.Alert.NetworkError.message
    }
}

extension Error {
    var isNetworkErrorCancelled: Bool {
        guard let error = self as? NetworkError else { return false }
        switch error {
        case .cancelled:
            return true
        default:
            return false
        }
    }
}

enum EmailError: LocalizedError {
    case serviceNotAvailable

    var errorDescription: String? {
        return L10n.Alert.MailClientError.message(L10n.Email.recipient)
    }
}
