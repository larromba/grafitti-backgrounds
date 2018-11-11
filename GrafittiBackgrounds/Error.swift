import Foundation

// TODO: localize

private let none = "If you're reading this, something went really wrong 😊"

enum PhotoResourceResponseError: LocalizedError {
    case malformedHTML
    case missingBaseURL
    case malformedBaseURL
    case missingPhotoURLs

    var errorDescription: String? {
        return "There was a problem reading from the network"
    }
}

enum PhotoAlbumsResponseError: LocalizedError {
    case malformedHTML
    case noPhotoAlbumsFound

    var errorDescription: String? {
        return "There was a problem reading from the network"
    }
}

enum PhotoResponseError: LocalizedError {
    case malformedHTML
    case missingImageURL
    case malformedImageURL

    var errorDescription: String? {
        return "There was a problem reading from the network"
    }
}

enum PhotoError: LocalizedError {
    case downloadInProgress
    case notEnoughImagesAvailable
    case notEnoughImagesDownloaded
    case imagesMissingAfterMove
    case fileDeleteError([PhotoResource])

    var errorDescription: String? {
        switch self {
        case .downloadInProgress:
            return none
        case .notEnoughImagesAvailable:
            return "There aren't enough images to download. Try reducing the number of photos in your preferences, and try again"
        case .notEnoughImagesDownloaded:
            return "We couldn't download enough images. Please Try again. If the problem persists, try reducing the number of photos in your preferences"
        case .imagesMissingAfterMove:
            return "Some images may be missing in your photos folder. Please check and try again"
        case .fileDeleteError:
            return "There was a problem deleting some of your photos. You might need to manually clear them"
        }
    }
}

enum PhotoStorageError: LocalizedError {
    case encodeError(Error)
    case decodeError(Error)
    case fileDeleteError(Error)
    case noRecord

    var errorDescription: String? {
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

enum PhotoServiceError: LocalizedError {
    case resourceMissingFileURL

    var errorDescription: String? {
        return none
    }
}

enum WorkspaceError: LocalizedError {
    case errorOpeningURL

    var errorDescription: String? {
        switch self {
        case .errorOpeningURL:
            return "Ther was a problem opening your folder"
        }
    }
}

enum PreferencesError: LocalizedError {
    case encodeError(Error)
    case decodeError(Error)

    var errorDescription: String? {
        switch self {
        case .encodeError:
            return "There was a problem writing your preferences"
        case .decodeError:
            return "There was a problem reading your preferences"
        }
    }
}

enum NetworkError: LocalizedError {
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

    var errorDescription: String? {
        guard !isCancelled else {
            return none
        }
        return "There was a problem with your network. Please try again"
    }
}

enum DataError: LocalizedError {
    case dataNotFound

    var errorDescription: String? {
        return none
    }
}

enum EmailError: LocalizedError {
    case serviceNotAvailable

    var errorDescription: String? {
        return "Your default mail client cannot be openned. Please send an email to: larromba@gmail.com"
    }
}
