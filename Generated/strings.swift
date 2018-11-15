// swiftlint:disable all
// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
internal enum L10n {

  internal enum Alert {
    internal enum CreatingDownloadFolderError {
      /// There was a problem creating your download folder. Please try again
      internal static let message = L10n.tr("Localized", "alert.creatingDownloadFolderError.message")
    }
    internal enum DeletePhotosError {
      /// There was a problem deleting some of your photos. You might need to manually clear them
      internal static let message = L10n.tr("Localized", "alert.deletePhotosError.message")
    }
    internal enum Foobar {
      /// If you're reading this, something went really wrong 😊
      internal static let message = L10n.tr("Localized", "alert.foobar.message")
    }
    internal enum GenericError {
      /// Error
      internal static let title = L10n.tr("Localized", "alert.genericError.title")
    }
    internal enum MailClientError {
      /// Your default mail client cannot be openned. Please send an email to: %@
      internal static func message(_ p1: String) -> String {
        return L10n.tr("Localized", "alert.mailClientError.message", p1)
      }
    }
    internal enum NetworkError {
      /// There was a problem with your network. Please try again
      internal static let message = L10n.tr("Localized", "alert.networkError.message")
    }
    internal enum NotEnoughImagesDownloaded {
      /// We couldn't download enough images. Please Try again. If the problem persists, try reducing the number of photos in your preferences
      internal static let message = L10n.tr("Localized", "alert.notEnoughImagesDownloaded.message")
    }
    internal enum NotEnoughImagesToDownload {
      /// There aren't enough images to download. Try reducing the number of photos in your preferences, and try again
      internal static let message = L10n.tr("Localized", "alert.notEnoughImagesToDownload.message")
    }
    internal enum OpeningFolderError {
      /// Ther was a problem opening your folder
      internal static let message = L10n.tr("Localized", "alert.openingFolderError.message")
    }
    internal enum PhotosCleared {
      /// Your photos were cleared
      internal static let message = L10n.tr("Localized", "alert.photosCleared.message")
      /// Success!
      internal static let title = L10n.tr("Localized", "alert.photosCleared.title")
    }
    internal enum ReadingPreferencesError {
      /// There was a problem reading your preferences
      internal static let message = L10n.tr("Localized", "alert.readingPreferencesError.message")
    }
    internal enum ReloadPhotosCancelled {
      /// Your reload was cancelled
      internal static let message = L10n.tr("Localized", "alert.reloadPhotosCancelled.message")
    }
    internal enum ReloadPhotosFinished {
      /// Your photos were reloaded
      internal static let message = L10n.tr("Localized", "alert.reloadPhotosFinished.message")
      /// Success!
      internal static let title = L10n.tr("Localized", "alert.reloadPhotosFinished.title")
    }
    internal enum ReloadPhotosStarted {
      /// Your photos are now refreshing
      internal static let message = L10n.tr("Localized", "alert.reloadPhotosStarted.message")
      /// Refreshing...
      internal static let title = L10n.tr("Localized", "alert.reloadPhotosStarted.title")
    }
    internal enum SavePhotoRecordError {
      /// There was a problem saving a record of your photos. You might need to manually clear your download folder and try again
      internal static let message = L10n.tr("Localized", "alert.savePhotoRecordError.message")
    }
    internal enum SomeImagesMissingAfterDownload {
      /// Some images may be missing in your photos folder. Please check and try again
      internal static let message = L10n.tr("Localized", "alert.someImagesMissingAfterDownload.message")
    }
    internal enum WritingPreferencesError {
      /// There was a problem writing your preferences
      internal static let message = L10n.tr("Localized", "alert.writingPreferencesError.message")
    }
  }

  internal enum Email {
    /// Please provide your steps to reproduce here:\n\n
    internal static let message = L10n.tr("Localized", "email.message")
    /// larromba@gmail.com
    internal static let recipient = L10n.tr("Localized", "email.recipient")
    /// %@ Bug Report
    internal static func subject(_ p1: String) -> String {
      return L10n.tr("Localized", "email.subject", p1)
    }
  }

  internal enum Menu {
    /// About
    internal static let about = L10n.tr("Localized", "menu.about")
    /// Cancel Refresh
    internal static let cancelRefresh = L10n.tr("Localized", "menu.cancelRefresh")
    /// Clear Folder
    internal static let clearFolder = L10n.tr("Localized", "menu.clearFolder")
    /// Help
    internal static let help = L10n.tr("Localized", "menu.Help")
    /// Open Folder
    internal static let openFolder = L10n.tr("Localized", "menu.openFolder")
    /// Preferences
    internal static let preferences = L10n.tr("Localized", "menu.preferences")
    /// Quit
    internal static let quit = L10n.tr("Localized", "menu.quit")
    /// Refresh Folder
    internal static let refreshFolder = L10n.tr("Localized", "menu.refreshFolder")
    /// Report Bug
    internal static let reportBug = L10n.tr("Localized", "menu.ReportBug")
    /// System Preferences
    internal static let systemPreferences = L10n.tr("Localized", "menu.systemPreferences")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
