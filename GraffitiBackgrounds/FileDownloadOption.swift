import Foundation

enum FileDownloadOption {
    case move(folder: URL)
    case moveReplaceName(folder: URL, newFileName: String)
    case moveReplaceExtension(folder: URL, newFileExtension: String)
    case replaceExtension(newFileExtension: String)
}
