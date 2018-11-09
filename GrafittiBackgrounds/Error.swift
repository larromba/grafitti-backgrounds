import Foundation

// TODO: localize

private let none = "If you're reading this, something went really wrong 😊"

enum PhotoResourceResponseError: Error {
    case malformedHTML
    case missingBaseURL
    case malformedBaseURL
    case missingPhotoURLs

    var localizedDescription: String {
        return "There was a problem reading from the network"
    }
}

enum PhotoAlbumsResponseError: Error {
    case malformedHTML
    case noPhotoAlbumsFound

    var localizedDescription: String {
        return "There was a problem reading from the network"
    }
}

enum PhotoResponseError: Error {
    case malformedHTML
    case missingImageURL
    case malformedImageURL

    var localizedDescription: String {
        return "There was a problem reading from the network"
    }
}

enum PhotoError: Error {
    case downloadInProgress
    case notEnoughImages
    case fileDeleteError([PhotoResource])

    var localizedDescription: String {
        switch self {
        case .downloadInProgress:
            return none
        case .notEnoughImages:
            return "We couldn't download enough images. Please Try again. If the problem persists, reduce the number of photos in your preferences"
        case .fileDeleteError:
            return "There was a problem deleting some of your photos. You might need to manually clear them"
        }
    }
}

enum PhotoStorageError: Error {
    case encodeError(Error)
    case decodeError(Error)
    case fileDeleteError(Error)
    case noRecord

    var localizedDescription: String {
        switch self {
        case .encodeError, .decodeError:
            return "There was a problem saving a record of your photos. You might need to manually clear your download folder and try again"
        case .fileDeleteError:
            return "There was a problem deleting some of your photos. You might need to manually clear them"
        case .noRecord:
            return none
        }
    }
}

enum PhotoServiceError: Error {
    case badSaveLocation

    var localizedDescription: String {
        return none
    }
}

enum WorkspaceError: Error {
    case errorOpeningURL

    var localizedDescription: String {
        switch self {
        case .errorOpeningURL:
            return "Ther was a problem opening your folder"
        }
    }
}

enum PreferencesError: Error {
    case encodeError(Error)
    case decodeError(Error)

    var localizedDescription: String {
        switch self {
        case .encodeError:
            return "There was a problem writing your preferences"
        case .decodeError:
            return "There was a problem reading your preferences"
        }
    }
}

enum NetworkError: Error {
    case noData
    case systemError(Error)
    case httpErrorCode(Int)
    case badResponse(Error)

    var isCancelled: Bool {
        switch self {
        case .systemError(let error):
            return (error as NSError).code == NSURLErrorCancelled
        default:
            return false
        }
    }

    var localizedDescription: String {
        guard !isCancelled else {
            return none
        }
        return "There was a problem with your network. Please try again"
    }
}

enum DataError: Error {
    case dataNotFound

    var localizedDescription: String {
        return none
    }
}
