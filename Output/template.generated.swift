// Generated using Sourcery 0.15.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// swiftlint:disable line_length
// swiftlint:disable variable_name

import Foundation
#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

@testable import Grafitti_Backgrounds






// MARK: - Sourcery Helper

protocol _StringRawRepresentable: RawRepresentable {
  var rawValue: String { get }
}

final class _Invocation {
  let name: String
  let date = Date()
  private var parameters: [String: Any] = [:]

  init(name: String) {
    self.name = name
  }

  fileprivate func set<T: _StringRawRepresentable>(parameter: Any, forKey key: T) {
    parameters[key.rawValue] = parameter
  }
  func parameter<T: _StringRawRepresentable>(for key: T) -> Any? {
    return parameters[key.rawValue]
  }
}

final class _Actions {
  enum Keys: String, _StringRawRepresentable {
    case closure
    case returnValue
    case defaultReturnValue
    case error
  }
  private var invocations: [_Invocation] = []

  // MARK: - closure

  func setClosure<T: _StringRawRepresentable>(_ value: () -> Void, for functionName: T) {
    let invocation = self.invocation(for: functionName)
    invocation.set(parameter: value, forKey: Keys.closure)
  }
  func closure<T: _StringRawRepresentable>(for functionName: T) -> (() -> Void)? {
    let invocation = self.invocation(for: functionName)
    return invocation.parameter(for: Keys.closure) as? (() -> Void)
  }

  // MARK: - returnValue

  func setReturnValue<T: _StringRawRepresentable>(_ value: Any, for functionName: T) {
    let invocation = self.invocation(for: functionName)
    invocation.set(parameter: value, forKey: Keys.returnValue)
  }
  func returnValue<T: _StringRawRepresentable>(for functionName: T) -> Any? {
    let invocation = self.invocation(for: functionName)
    return invocation.parameter(for: Keys.returnValue) ?? invocation.parameter(for: Keys.defaultReturnValue)
  }

  // MARK: - defaultReturnValue

  fileprivate func setDefaultReturnValue<T: _StringRawRepresentable>(_ value: Any, for functionName: T) {
    let invocation = self.invocation(for: functionName)
    invocation.set(parameter: value, forKey: Keys.defaultReturnValue)
  }
  fileprivate func defaultReturnValue<T: _StringRawRepresentable>(for functionName: T) -> Any? {
    let invocation = self.invocation(for: functionName)
    return invocation.parameter(for: Keys.defaultReturnValue) as? (() -> Void)
  }

  // MARK: - error

  func setError<T: _StringRawRepresentable>(_ value: Error, for functionName: T) {
    let invocation = self.invocation(for: functionName)
    invocation.set(parameter: value, forKey: Keys.error)
  }
  func error<T: _StringRawRepresentable>(for functionName: T) -> Error? {
    let invocation = self.invocation(for: functionName)
    return invocation.parameter(for: Keys.error) as? Error
  }

  // MARK: - private

  private func invocation<T: _StringRawRepresentable>(for name: T) -> _Invocation {
    if let invocation = invocations.filter({ $0.name == name.rawValue }).first {
      return invocation
    }
    let invocation = _Invocation(name: name.rawValue)
    invocations += [invocation]
    return invocation
  }
}

final class _Invocations {
  private var history = [_Invocation]()

  fileprivate func record(_ invocation: _Invocation) {
    history += [invocation]
  }

  func isInvoked<T: _StringRawRepresentable>(_ name: T) -> Bool {
    return history.contains(where: { $0.name == name.rawValue })
  }

  func numOfTimesInvoked<T: _StringRawRepresentable>(_ name: T) -> Int {
    return history.filter {  $0.name == name.rawValue }.count
  }

  func allInvocations() -> [_Invocation] {
    return history.sorted { $0.date < $1.date }
  }

  func findInvocations<T: _StringRawRepresentable>(for name: T) -> [_Invocation] {
    return history.filter {  $0.name == name.rawValue }.sorted { $0.date < $1.date }
  }

  func findParameter<T: _StringRawRepresentable, U: _StringRawRepresentable>(_ key: T, inFunction name: U) -> Any? {
    return history.filter {  $0.name == name.rawValue }.first?.parameter(for: key)
  }
}

// MARK: - Sourcery Mocks

class MockAppController: NSObject, AppControllable {
    var preferencesController: PreferencesControllable {
        get { return _preferencesController }
        set(value) { _preferencesController = value }
    }
    var _preferencesController: PreferencesControllable! = MockPreferencesController()
    var workspaceController: WorkspaceControllable {
        get { return _workspaceController }
        set(value) { _workspaceController = value }
    }
    var _workspaceController: WorkspaceControllable! = MockWorkspaceController()
    var menuController: MenuControllable {
        get { return _menuController }
        set(value) { _menuController = value }
    }
    var _menuController: MenuControllable! = MockMenuController()
    var photoController: PhotoControllable {
        get { return _photoController }
        set(value) { _photoController = value }
    }
    var _photoController: PhotoControllable! = MockPhotoController()
    var app: Applicationable {
        get { return _app }
        set(value) { _app = value }
    }
    var _app: Applicationable! = MockApplication()
    let invocations = _Invocations()
    let actions = _Actions()

    enum funcs: String, _StringRawRepresentable {
      case start1
    }

    //MARK: - start

    func start() {
        let functionName = funcs.start1
        let invocation = _Invocation(name: functionName.rawValue)
        invocations.record(invocation)
        actions.closure(for: functionName)?()
    }
}

class MockAppDelegate: NSObject, AppDelegatable {
    var appController: AppControllable {
        get { return _appController }
        set(value) { _appController = value }
    }
    var _appController: AppControllable! = MockAppController()
}

class MockApplication: NSObject, Applicationable {
    let invocations = _Invocations()
    let actions = _Actions()

    enum funcs: String, _StringRawRepresentable {
      case orderFrontStandardAboutPanel1
      case orderFrontStandardAboutPanel2
      case terminate3
    }
    enum orderFrontStandardAboutPanel1Parameters: String, _StringRawRepresentable {
      case sender = "orderFrontStandardAboutPanel(_ sender: Any?).sender"
    }
    enum orderFrontStandardAboutPanel2Parameters: String, _StringRawRepresentable {
      case optionsDictionary = "orderFrontStandardAboutPanel(options optionsDictionary: [NSApplication.AboutPanelOptionKey : Any]).optionsDictionary"
    }
    enum terminate3Parameters: String, _StringRawRepresentable {
      case sender = "terminate(_ sender: Any?).sender"
    }

    //MARK: - orderFrontStandardAboutPanel

    func orderFrontStandardAboutPanel(_ sender: Any?) {
        let functionName = funcs.orderFrontStandardAboutPanel1
        let invocation = _Invocation(name: functionName.rawValue)
        if let sender = sender {
            invocation.set(parameter: sender, forKey: orderFrontStandardAboutPanel1Parameters.sender)
        }
        invocations.record(invocation)
        actions.closure(for: functionName)?()
    }

    //MARK: - orderFrontStandardAboutPanel

    func orderFrontStandardAboutPanel(options optionsDictionary: [NSApplication.AboutPanelOptionKey : Any]) {
        let functionName = funcs.orderFrontStandardAboutPanel2
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: optionsDictionary, forKey: orderFrontStandardAboutPanel2Parameters.optionsDictionary)
        invocations.record(invocation)
        actions.closure(for: functionName)?()
    }

    //MARK: - terminate

    func terminate(_ sender: Any?) {
        let functionName = funcs.terminate3
        let invocation = _Invocation(name: functionName.rawValue)
        if let sender = sender {
            invocation.set(parameter: sender, forKey: terminate3Parameters.sender)
        }
        invocations.record(invocation)
        actions.closure(for: functionName)?()
    }
}

class MockDataManger: NSObject, DataManaging {
    let invocations = _Invocations()
    let actions = _Actions()

    enum funcs: String, _StringRawRepresentable {
      case save1
      case load2
    }
    enum save1Parameters: String, _StringRawRepresentable {
      case data = "save(_ data: Data?, key: String).data"
      case key = "save(_ data: Data?, key: String).key"
    }
    enum load2Parameters: String, _StringRawRepresentable {
      case key = "load(key: String).key"
    }

    //MARK: - save

    func save(_ data: Data?, key: String) {
        let functionName = funcs.save1
        let invocation = _Invocation(name: functionName.rawValue)
        if let data = data {
            invocation.set(parameter: data, forKey: save1Parameters.data)
        }
        invocation.set(parameter: key, forKey: save1Parameters.key)
        invocations.record(invocation)
        actions.closure(for: functionName)?()
    }

    //MARK: - load

    func load(key: String) -> Data? {
        let functionName = funcs.load2
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: key, forKey: load2Parameters.key)
        invocations.record(invocation)
        actions.closure(for: functionName)?()
        return actions.returnValue(for: functionName) as? Data
    }
}

class MockFileManager: NSObject, FileManaging {
    let invocations = _Invocations()
    let actions = _Actions()

    enum funcs: String, _StringRawRepresentable {
      case removeItem1
      case moveItem2
      case createDirectory3
      case fileExists4
    }
    enum removeItem1Parameters: String, _StringRawRepresentable {
      case URL = "removeItem(at URL: URL).URL"
    }
    enum moveItem2Parameters: String, _StringRawRepresentable {
      case srcURL = "moveItem(at srcURL: URL, to dstURL: URL).srcURL"
      case dstURL = "moveItem(at srcURL: URL, to dstURL: URL).dstURL"
    }
    enum createDirectory3Parameters: String, _StringRawRepresentable {
      case url = "createDirectory(at url: URL, withIntermediateDirectories createIntermediates: Bool, attributes: [FileAttributeKey : Any]?).url"
      case createIntermediates = "createDirectory(at url: URL, withIntermediateDirectories createIntermediates: Bool, attributes: [FileAttributeKey : Any]?).createIntermediates"
      case attributes = "createDirectory(at url: URL, withIntermediateDirectories createIntermediates: Bool, attributes: [FileAttributeKey : Any]?).attributes"
    }
    enum fileExists4Parameters: String, _StringRawRepresentable {
      case path = "fileExists(atPath path: String).path"
    }

    //MARK: - removeItem

    func removeItem(at URL: URL) throws {
        let functionName = funcs.removeItem1
        if let error = actions.error(for: functionName) {
            throw error
        }
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: URL, forKey: removeItem1Parameters.URL)
        invocations.record(invocation)
        actions.closure(for: functionName)?()
    }

    //MARK: - moveItem

    func moveItem(at srcURL: URL, to dstURL: URL) throws {
        let functionName = funcs.moveItem2
        if let error = actions.error(for: functionName) {
            throw error
        }
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: srcURL, forKey: moveItem2Parameters.srcURL)
        invocation.set(parameter: dstURL, forKey: moveItem2Parameters.dstURL)
        invocations.record(invocation)
        actions.closure(for: functionName)?()
    }

    //MARK: - createDirectory

    func createDirectory(at url: URL, withIntermediateDirectories createIntermediates: Bool, attributes: [FileAttributeKey : Any]?) throws {
        let functionName = funcs.createDirectory3
        if let error = actions.error(for: functionName) {
            throw error
        }
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: url, forKey: createDirectory3Parameters.url)
        invocation.set(parameter: createIntermediates, forKey: createDirectory3Parameters.createIntermediates)
        if let attributes = attributes {
            invocation.set(parameter: attributes, forKey: createDirectory3Parameters.attributes)
        }
        invocations.record(invocation)
        actions.closure(for: functionName)?()
    }

    //MARK: - fileExists

    func fileExists(atPath path: String) -> Bool {
        let functionName = funcs.fileExists4
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: path, forKey: fileExists4Parameters.path)
        invocations.record(invocation)
        actions.closure(for: functionName)?()
        actions.setDefaultReturnValue(true, for: functionName)
        return actions.returnValue(for: functionName) as! Bool
    }
}

class MockLoadingStatusItem: NSObject, LoadingStatusItemable {
    var statusBar: NSStatusBar {
        get { return _statusBar }
        set(value) { _statusBar = value }
    }
    var _statusBar: NSStatusBar! = NSStatusBar()
    var item: NSStatusItem {
        get { return _item }
        set(value) { _item = value }
    }
    var _item: NSStatusItem! = NSStatusItem()
    var isLoading: Bool {
        get { return _isLoading }
        set(value) { _isLoading = value }
    }
    var _isLoading: Bool!
    var loadingPercentage: Double {
        get { return _loadingPercentage }
        set(value) { _loadingPercentage = value }
    }
    var _loadingPercentage: Double!
    var viewModel: LoadingStatusItemViewModel {
        get { return _viewModel }
        set(value) { _viewModel = value }
    }
    var _viewModel: LoadingStatusItemViewModel!
}

class MockMenuController: NSObject, MenuControllable {
    var statusItem: LoadingStatusItemable {
        get { return _statusItem }
        set(value) { _statusItem = value }
    }
    var _statusItem: LoadingStatusItemable! = MockLoadingStatusItem()
    var delegate: MenuControllerDelegate?
    let invocations = _Invocations()
    let actions = _Actions()

    enum funcs: String, _StringRawRepresentable {
      case setLoadingPercentage1
      case setIsLoading2
      case setRefreshAction3
    }
    enum setLoadingPercentage1Parameters: String, _StringRawRepresentable {
      case percentage = "setLoadingPercentage(_ percentage: Double).percentage"
    }
    enum setIsLoading2Parameters: String, _StringRawRepresentable {
      case isLoading = "setIsLoading(_ isLoading: Bool).isLoading"
    }
    enum setRefreshAction3Parameters: String, _StringRawRepresentable {
      case action = "setRefreshAction(_ action: AppMenu.Action.Refresh).action"
    }

    //MARK: - setLoadingPercentage

    func setLoadingPercentage(_ percentage: Double) {
        let functionName = funcs.setLoadingPercentage1
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: percentage, forKey: setLoadingPercentage1Parameters.percentage)
        invocations.record(invocation)
        actions.closure(for: functionName)?()
    }

    //MARK: - setIsLoading

    func setIsLoading(_ isLoading: Bool) {
        let functionName = funcs.setIsLoading2
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: isLoading, forKey: setIsLoading2Parameters.isLoading)
        invocations.record(invocation)
        actions.closure(for: functionName)?()
    }

    //MARK: - setRefreshAction

    func setRefreshAction(_ action: AppMenu.Action.Refresh) {
        let functionName = funcs.setRefreshAction3
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: action, forKey: setRefreshAction3Parameters.action)
        invocations.record(invocation)
        actions.closure(for: functionName)?()
    }
}

class MockMenuItem: NSObject, MenuItemable {
    var delegate: MenuItemDelegate?
    var viewModel: MenuItemViewModel {
        get { return _viewModel }
        set(value) { _viewModel = value }
    }
    var _viewModel: MenuItemViewModel!
}

class MockMenu: NSObject, Menuable {
    var viewModel: MenuViewModel {
        get { return _viewModel }
        set(value) { _viewModel = value }
    }
    var _viewModel: MenuViewModel!
    let invocations = _Invocations()
    let actions = _Actions()

    enum funcs: String, _StringRawRepresentable {
      case item1
    }
    enum item1Parameters: String, _StringRawRepresentable {
      case index = "item(at index: Int).index"
    }

    //MARK: - item

    func item(at index: Int) -> MenuItemable? {
        let functionName = funcs.item1
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: index, forKey: item1Parameters.index)
        invocations.record(invocation)
        actions.closure(for: functionName)?()
        return actions.returnValue(for: functionName) as? MenuItemable
    }
}

class MockNetworkManager: NSObject, NetworkManaging {
    let invocations = _Invocations()
    let actions = _Actions()

    enum funcs: String, _StringRawRepresentable {
      case send1
      case download2
      case cancelAll3
    }
    enum send1Parameters: String, _StringRawRepresentable {
      case request = "send(request: Request, success: @escaping ((Response) -> ()), failure: @escaping ((Error) -> ())).request"
      case success = "send(request: Request, success: @escaping ((Response) -> ()), failure: @escaping ((Error) -> ())).success"
      case failure = "send(request: Request, success: @escaping ((Response) -> ()), failure: @escaping ((Error) -> ())).failure"
    }
    enum download2Parameters: String, _StringRawRepresentable {
      case url = "download(_ url: URL, success: @escaping ((URL) -> ()), failure: @escaping ((Error) -> ())).url"
      case success = "download(_ url: URL, success: @escaping ((URL) -> ()), failure: @escaping ((Error) -> ())).success"
      case failure = "download(_ url: URL, success: @escaping ((URL) -> ()), failure: @escaping ((Error) -> ())).failure"
    }

    //MARK: - send

    func send(request: Request, success: @escaping ((Response) -> ()), failure: @escaping ((Error) -> ())) {
        let functionName = funcs.send1
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: request, forKey: send1Parameters.request)
        invocation.set(parameter: success, forKey: send1Parameters.success)
        invocation.set(parameter: failure, forKey: send1Parameters.failure)
        invocations.record(invocation)
        actions.closure(for: functionName)?()
    }

    //MARK: - download

    func download(_ url: URL, success: @escaping ((URL) -> ()), failure: @escaping ((Error) -> ())) {
        let functionName = funcs.download2
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: url, forKey: download2Parameters.url)
        invocation.set(parameter: success, forKey: download2Parameters.success)
        invocation.set(parameter: failure, forKey: download2Parameters.failure)
        invocations.record(invocation)
        actions.closure(for: functionName)?()
    }

    //MARK: - cancelAll

    func cancelAll() {
        let functionName = funcs.cancelAll3
        let invocation = _Invocation(name: functionName.rawValue)
        invocations.record(invocation)
        actions.closure(for: functionName)?()
    }
}

class MockPhotoAlbumService: NSObject, PhotoAlbumServicing {
    var networkManager: NetworkManaging {
        get { return _networkManager }
        set(value) { _networkManager = value }
    }
    var _networkManager: NetworkManaging! = MockNetworkManager()
    let invocations = _Invocations()
    let actions = _Actions()

    enum funcs: String, _StringRawRepresentable {
      case getPhotoAlbums1
      case getPhotoResources2
      case cancelAll3
    }
    enum getPhotoAlbums1Parameters: String, _StringRawRepresentable {
      case success = "getPhotoAlbums(success: @escaping (([PhotoAlbum]) -> ()), failure: ((Error) -> ())?).success"
      case failure = "getPhotoAlbums(success: @escaping (([PhotoAlbum]) -> ()), failure: ((Error) -> ())?).failure"
    }
    enum getPhotoResources2Parameters: String, _StringRawRepresentable {
      case album = "getPhotoResources(_ album: PhotoAlbum, success: @escaping (([PhotoResource]) -> ()), failure: ((Error) -> ())?).album"
      case success = "getPhotoResources(_ album: PhotoAlbum, success: @escaping (([PhotoResource]) -> ()), failure: ((Error) -> ())?).success"
      case failure = "getPhotoResources(_ album: PhotoAlbum, success: @escaping (([PhotoResource]) -> ()), failure: ((Error) -> ())?).failure"
    }

    //MARK: - getPhotoAlbums

    func getPhotoAlbums(success: @escaping (([PhotoAlbum]) -> ()), failure: ((Error) -> ())?) {
        let functionName = funcs.getPhotoAlbums1
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: success, forKey: getPhotoAlbums1Parameters.success)
        if let failure = failure {
            invocation.set(parameter: failure, forKey: getPhotoAlbums1Parameters.failure)
        }
        invocations.record(invocation)
        actions.closure(for: functionName)?()
    }

    //MARK: - getPhotoResources

    func getPhotoResources(_ album: PhotoAlbum, success: @escaping (([PhotoResource]) -> ()), failure: ((Error) -> ())?) {
        let functionName = funcs.getPhotoResources2
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: album, forKey: getPhotoResources2Parameters.album)
        invocation.set(parameter: success, forKey: getPhotoResources2Parameters.success)
        if let failure = failure {
            invocation.set(parameter: failure, forKey: getPhotoResources2Parameters.failure)
        }
        invocations.record(invocation)
        actions.closure(for: functionName)?()
    }

    //MARK: - cancelAll

    func cancelAll() {
        let functionName = funcs.cancelAll3
        let invocation = _Invocation(name: functionName.rawValue)
        invocations.record(invocation)
        actions.closure(for: functionName)?()
    }
}

class MockPhotoController: NSObject, PhotoControllable {
    var photoAlbumService: PhotoAlbumServicing {
        get { return _photoAlbumService }
        set(value) { _photoAlbumService = value }
    }
    var _photoAlbumService: PhotoAlbumServicing! = MockPhotoAlbumService()
    var photoService: PhotoServicing {
        get { return _photoService }
        set(value) { _photoService = value }
    }
    var _photoService: PhotoServicing! = MockPhotoService()
    var photoStorageService: PhotoStorageServicing {
        get { return _photoStorageService }
        set(value) { _photoStorageService = value }
    }
    var _photoStorageService: PhotoStorageServicing! = MockPhotoStorageService()
    var isDownloadInProgress: Bool {
        get { return _isDownloadInProgress }
        set(value) { _isDownloadInProgress = value }
    }
    var _isDownloadInProgress: Bool!
    var preferences: Preferences {
        get { return _preferences }
        set(value) { _preferences = value }
    }
    var _preferences: Preferences!
    var folderURL: URL {
        get { return _folderURL }
        set(value) { _folderURL = value }
    }
    var _folderURL: URL!
    var delegate: PhotoControllerDelegate?
    let invocations = _Invocations()
    let actions = _Actions()

    enum funcs: String, _StringRawRepresentable {
      case reloadPhotos1
      case cancelReload2
      case cleanFolder3
    }

    //MARK: - reloadPhotos

    func reloadPhotos() {
        let functionName = funcs.reloadPhotos1
        let invocation = _Invocation(name: functionName.rawValue)
        invocations.record(invocation)
        actions.closure(for: functionName)?()
    }

    //MARK: - cancelReload

    func cancelReload() {
        let functionName = funcs.cancelReload2
        let invocation = _Invocation(name: functionName.rawValue)
        invocations.record(invocation)
        actions.closure(for: functionName)?()
    }

    //MARK: - cleanFolder

    func cleanFolder() {
        let functionName = funcs.cleanFolder3
        let invocation = _Invocation(name: functionName.rawValue)
        invocations.record(invocation)
        actions.closure(for: functionName)?()
    }
}

class MockPhotoService: NSObject, PhotoServicing {
    var networkManager: NetworkManaging {
        get { return _networkManager }
        set(value) { _networkManager = value }
    }
    var _networkManager: NetworkManaging! = MockNetworkManager()
    var fileManager: FileManaging {
        get { return _fileManager }
        set(value) { _fileManager = value }
    }
    var _fileManager: FileManaging! = MockFileManager()
    var saveURL: URL {
        get { return _saveURL }
        set(value) { _saveURL = value }
    }
    var _saveURL: URL!
    let invocations = _Invocations()
    let actions = _Actions()

    enum funcs: String, _StringRawRepresentable {
      case downloadPhoto1
      case cancelAll2
    }
    enum downloadPhoto1Parameters: String, _StringRawRepresentable {
      case resource = "downloadPhoto(_ resource: PhotoResource, success: @escaping ((PhotoResource) -> ()), failure: ((Error) -> ())?).resource"
      case success = "downloadPhoto(_ resource: PhotoResource, success: @escaping ((PhotoResource) -> ()), failure: ((Error) -> ())?).success"
      case failure = "downloadPhoto(_ resource: PhotoResource, success: @escaping ((PhotoResource) -> ()), failure: ((Error) -> ())?).failure"
    }

    //MARK: - downloadPhoto

    func downloadPhoto(_ resource: PhotoResource, success: @escaping ((PhotoResource) -> ()), failure: ((Error) -> ())?) {
        let functionName = funcs.downloadPhoto1
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: resource, forKey: downloadPhoto1Parameters.resource)
        invocation.set(parameter: success, forKey: downloadPhoto1Parameters.success)
        if let failure = failure {
            invocation.set(parameter: failure, forKey: downloadPhoto1Parameters.failure)
        }
        invocations.record(invocation)
        actions.closure(for: functionName)?()
    }

    //MARK: - cancelAll

    func cancelAll() {
        let functionName = funcs.cancelAll2
        let invocation = _Invocation(name: functionName.rawValue)
        invocations.record(invocation)
        actions.closure(for: functionName)?()
    }
}

class MockPhotoStorageService: NSObject, PhotoStorageServicing {
    var dataManager: DataManaging {
        get { return _dataManager }
        set(value) { _dataManager = value }
    }
    var _dataManager: DataManaging! = MockDataManger()
    var fileManager: FileManaging {
        get { return _fileManager }
        set(value) { _fileManager = value }
    }
    var _fileManager: FileManaging! = MockFileManager()
    let invocations = _Invocations()
    let actions = _Actions()

    enum funcs: String, _StringRawRepresentable {
      case save1
      case load2
      case remove3
    }
    enum save1Parameters: String, _StringRawRepresentable {
      case resources = "save(_ resources: [PhotoResource]).resources"
    }
    enum remove3Parameters: String, _StringRawRepresentable {
      case resources = "remove(_ resources: [PhotoResource]).resources"
    }

    //MARK: - save

    func save(_ resources: [PhotoResource]) {
        let functionName = funcs.save1
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: resources, forKey: save1Parameters.resources)
        invocations.record(invocation)
        actions.closure(for: functionName)?()
    }

    //MARK: - load

    func load() -> [PhotoResource]? {
        let functionName = funcs.load2
        let invocation = _Invocation(name: functionName.rawValue)
        invocations.record(invocation)
        actions.closure(for: functionName)?()
        return actions.returnValue(for: functionName) as? [PhotoResource]
    }

    //MARK: - remove

    func remove(_ resources: [PhotoResource]) {
        let functionName = funcs.remove3
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: resources, forKey: remove3Parameters.resources)
        invocations.record(invocation)
        actions.closure(for: functionName)?()
    }
}

class MockPreferencesController: NSObject, PreferencesControllable {
    var windowController: WindowControlling {
        get { return _windowController }
        set(value) { _windowController = value }
    }
    var _windowController: WindowControlling! = MockWindowController()
    var preferencesViewController: PreferencesViewControllable {
        get { return _preferencesViewController }
        set(value) { _preferencesViewController = value }
    }
    var _preferencesViewController: PreferencesViewControllable! = MockPreferencesViewController()
    var preferencesService: PreferencesServicing {
        get { return _preferencesService }
        set(value) { _preferencesService = value }
    }
    var _preferencesService: PreferencesServicing! = MockPreferencesService()
    var preferences: Preferences {
        get { return _preferences }
        set(value) { _preferences = value }
    }
    var _preferences: Preferences! = Preferences()
    var delegate: PreferencesControllerDelegate?
    let invocations = _Invocations()
    let actions = _Actions()

    enum funcs: String, _StringRawRepresentable {
      case open1
    }

    //MARK: - open

    func open() {
        let functionName = funcs.open1
        let invocation = _Invocation(name: functionName.rawValue)
        invocations.record(invocation)
        actions.closure(for: functionName)?()
    }
}

class MockPreferencesService: NSObject, PreferencesServicing {
    var dataManager: DataManaging {
        get { return _dataManager }
        set(value) { _dataManager = value }
    }
    var _dataManager: DataManaging! = MockDataManger()
    let invocations = _Invocations()
    let actions = _Actions()

    enum funcs: String, _StringRawRepresentable {
      case save1
      case load2
    }
    enum save1Parameters: String, _StringRawRepresentable {
      case preferences = "save(_ preferences: Preferences).preferences"
    }

    //MARK: - save

    func save(_ preferences: Preferences) {
        let functionName = funcs.save1
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: preferences, forKey: save1Parameters.preferences)
        invocations.record(invocation)
        actions.closure(for: functionName)?()
    }

    //MARK: - load

    func load() -> Preferences? {
        let functionName = funcs.load2
        let invocation = _Invocation(name: functionName.rawValue)
        invocations.record(invocation)
        actions.closure(for: functionName)?()
        return actions.returnValue(for: functionName) as? Preferences
    }
}

class MockPreferencesViewController: NSViewController, PreferencesViewControllable {
    var autoRefreshCheckBoxTextLabel: ReadOnlyTextField! = NSTextField()
    var autoRefreshCheckBox: ReadOnlyButton! = NSButton()
    var autoRefreshIntervalTextLabel: ReadOnlyTextField! = NSTextField()
    var autoRefreshIntervalTextField: ReadOnlyTextField! = NSTextField()
    var numberOfPhotosTextLabel: ReadOnlyTextField! = NSTextField()
    var numberOfPhotosTextField: ReadOnlyTextField! = NSTextField()
    var delegate: PreferencesViewControllerDelegate?
    var viewModel: PreferencesViewModel?
}

class MockWindowController: NSObject, WindowControlling {
    var contentViewController: NSViewController?
    let invocations = _Invocations()
    let actions = _Actions()

    enum funcs: String, _StringRawRepresentable {
      case showWindow1
    }
    enum showWindow1Parameters: String, _StringRawRepresentable {
      case sender = "showWindow(_ sender: Any?).sender"
    }

    //MARK: - showWindow

    func showWindow(_ sender: Any?) {
        let functionName = funcs.showWindow1
        let invocation = _Invocation(name: functionName.rawValue)
        if let sender = sender {
            invocation.set(parameter: sender, forKey: showWindow1Parameters.sender)
        }
        invocations.record(invocation)
        actions.closure(for: functionName)?()
    }
}

class MockWorkspaceController: NSObject, WorkspaceControllable {
    var workspace: Workspacing {
        get { return _workspace }
        set(value) { _workspace = value }
    }
    var _workspace: Workspacing! = MockWorkspace()
    let invocations = _Invocations()
    let actions = _Actions()

    enum funcs: String, _StringRawRepresentable {
      case open1
      case open2
    }
    enum open1Parameters: String, _StringRawRepresentable {
      case preference = "open(_ preference: SystemPreference).preference"
    }
    enum open2Parameters: String, _StringRawRepresentable {
      case url = "open(_ url: URL).url"
    }

    //MARK: - open

    func open(_ preference: SystemPreference) {
        let functionName = funcs.open1
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: preference, forKey: open1Parameters.preference)
        invocations.record(invocation)
        actions.closure(for: functionName)?()
    }

    //MARK: - open

    func open(_ url: URL) {
        let functionName = funcs.open2
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: url, forKey: open2Parameters.url)
        invocations.record(invocation)
        actions.closure(for: functionName)?()
    }
}

class MockWorkspace: NSObject, Workspacing {
    let invocations = _Invocations()
    let actions = _Actions()

    enum funcs: String, _StringRawRepresentable {
      case open1
    }
    enum open1Parameters: String, _StringRawRepresentable {
      case url = "open(_ url: URL).url"
    }

    //MARK: - open

    func open(_ url: URL) -> Bool {
        let functionName = funcs.open1
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: url, forKey: open1Parameters.url)
        invocations.record(invocation)
        actions.closure(for: functionName)?()
        actions.setDefaultReturnValue(true, for: functionName)
        return actions.returnValue(for: functionName) as! Bool
    }
}
