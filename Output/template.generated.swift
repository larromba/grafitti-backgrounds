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

  func set<T: _StringRawRepresentable>(closure: @escaping () -> Void, for functionName: T) {
    let invocation = self.invocation(for: functionName)
    invocation.set(parameter: closure, forKey: Keys.closure)
  }
  func closure<T: _StringRawRepresentable>(for functionName: T) -> (() -> Void)? {
    let invocation = self.invocation(for: functionName)
    return invocation.parameter(for: Keys.closure) as? (() -> Void)
  }

  // MARK: - returnValue

  func set<T: _StringRawRepresentable>(returnValue value: Any, for functionName: T) {
    let invocation = self.invocation(for: functionName)
    invocation.set(parameter: value, forKey: Keys.returnValue)
  }
  func returnValue<T: _StringRawRepresentable>(for functionName: T) -> Any? {
    let invocation = self.invocation(for: functionName)
    return invocation.parameter(for: Keys.returnValue) ?? invocation.parameter(for: Keys.defaultReturnValue)
  }

  // MARK: - defaultReturnValue

  fileprivate func set<T: _StringRawRepresentable>(defaultReturnValue value: Any, for functionName: T) {
    let invocation = self.invocation(for: functionName)
    invocation.set(parameter: value, forKey: Keys.defaultReturnValue)
  }
  fileprivate func defaultReturnValue<T: _StringRawRepresentable>(for functionName: T) -> Any? {
    let invocation = self.invocation(for: functionName)
    return invocation.parameter(for: Keys.defaultReturnValue) as? (() -> Void)
  }

  // MARK: - error

  func set<T: _StringRawRepresentable>(error: Error, for functionName: T) {
    let invocation = self.invocation(for: functionName)
    invocation.set(parameter: error, forKey: Keys.error)
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

  func count<T: _StringRawRepresentable>(_ name: T) -> Int {
    return history.filter {  $0.name == name.rawValue }.count
  }

  func all() -> [_Invocation] {
    return history.sorted { $0.date < $1.date }
  }

  func find<T: _StringRawRepresentable>(_ name: T) -> [_Invocation] {
    return history.filter {  $0.name == name.rawValue }.sorted { $0.date < $1.date }
  }

  func find<T: _StringRawRepresentable, U: _StringRawRepresentable>(parameter: T, inFunction name: U) -> Any? {
    return history.filter { $0.name == name.rawValue }.first?.parameter(for: parameter)
  }
}

// MARK: - Sourcery Mocks

class MockAlertController: NSObject, AlertControlling {
    let invocations = _Invocations()
    let actions = _Actions()

    // MARK: - showAlert

    func showAlert(_ alert: Alert) {
        let functionName = showAlert1.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: alert, forKey: showAlert1.params.alert)
        invocations.record(invocation)
        actions.closure(for: functionName)?()
    }

    enum showAlert1: String, _StringRawRepresentable {
      case name = "showAlert1"
      enum params: String, _StringRawRepresentable {
        case alert = "showAlert(_alert:Alert).alert"
      }
    }
}

class MockAppController: NSObject, AppControllable {
    let invocations = _Invocations()
    let actions = _Actions()

    // MARK: - start

    func start() {
        let functionName = start1.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocations.record(invocation)
        actions.closure(for: functionName)?()
    }

    enum start1: String, _StringRawRepresentable {
      case name = "start1"
    }
}

class MockAppDelegate: NSObject, AppDelegatable {
}

class MockAppMenuController: NSObject, AppMenuControllable {
    let invocations = _Invocations()
    let actions = _Actions()

    // MARK: - setLoadingPercentage

    func setLoadingPercentage(_ percentage: Double) {
        let functionName = setLoadingPercentage1.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: percentage, forKey: setLoadingPercentage1.params.percentage)
        invocations.record(invocation)
        actions.closure(for: functionName)?()
    }

    enum setLoadingPercentage1: String, _StringRawRepresentable {
      case name = "setLoadingPercentage1"
      enum params: String, _StringRawRepresentable {
        case percentage = "setLoadingPercentage(_percentage:Double).percentage"
      }
    }

    // MARK: - setIsLoading

    func setIsLoading(_ isLoading: Bool) {
        let functionName = setIsLoading2.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: isLoading, forKey: setIsLoading2.params.isLoading)
        invocations.record(invocation)
        actions.closure(for: functionName)?()
    }

    enum setIsLoading2: String, _StringRawRepresentable {
      case name = "setIsLoading2"
      enum params: String, _StringRawRepresentable {
        case isLoading = "setIsLoading(_isLoading:Bool).isLoading"
      }
    }

    // MARK: - setRefreshAction

    func setRefreshAction(_ action: AppMenu.Action.Refresh) {
        let functionName = setRefreshAction3.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: action, forKey: setRefreshAction3.params.action)
        invocations.record(invocation)
        actions.closure(for: functionName)?()
    }

    enum setRefreshAction3: String, _StringRawRepresentable {
      case name = "setRefreshAction3"
      enum params: String, _StringRawRepresentable {
        case action = "setRefreshAction(_action:AppMenu.Action.Refresh).action"
      }
    }

    // MARK: - setDelegate

    func setDelegate(_ delegate: AppMenuControllerDelegate) {
        let functionName = setDelegate4.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: delegate, forKey: setDelegate4.params.delegate)
        invocations.record(invocation)
        actions.closure(for: functionName)?()
    }

    enum setDelegate4: String, _StringRawRepresentable {
      case name = "setDelegate4"
      enum params: String, _StringRawRepresentable {
        case delegate = "setDelegate(_delegate:AppMenuControllerDelegate).delegate"
      }
    }
}

class MockApplication: NSObject, Applicationable {
    let invocations = _Invocations()
    let actions = _Actions()

    // MARK: - orderFrontStandardAboutPanel

    func orderFrontStandardAboutPanel(_ sender: Any?) {
        let functionName = orderFrontStandardAboutPanel1.name
        let invocation = _Invocation(name: functionName.rawValue)
        if let sender = sender {
            invocation.set(parameter: sender, forKey: orderFrontStandardAboutPanel1.params.sender)
        }
        invocations.record(invocation)
        actions.closure(for: functionName)?()
    }

    enum orderFrontStandardAboutPanel1: String, _StringRawRepresentable {
      case name = "orderFrontStandardAboutPanel1"
      enum params: String, _StringRawRepresentable {
        case sender = "orderFrontStandardAboutPanel(_sender:Any?).sender"
      }
    }

    // MARK: - orderFrontStandardAboutPanel

    func orderFrontStandardAboutPanel(options optionsDictionary: [NSApplication.AboutPanelOptionKey: Any]) {
        let functionName = orderFrontStandardAboutPanel2.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: optionsDictionary, forKey: orderFrontStandardAboutPanel2.params.optionsDictionary)
        invocations.record(invocation)
        actions.closure(for: functionName)?()
    }

    enum orderFrontStandardAboutPanel2: String, _StringRawRepresentable {
      case name = "orderFrontStandardAboutPanel2"
      enum params: String, _StringRawRepresentable {
        case optionsDictionary = "orderFrontStandardAboutPanel(optionsoptionsDictionary:[NSApplication.AboutPanelOptionKey:Any]).optionsDictionary"
      }
    }

    // MARK: - terminate

    func terminate(_ sender: Any?) {
        let functionName = terminate3.name
        let invocation = _Invocation(name: functionName.rawValue)
        if let sender = sender {
            invocation.set(parameter: sender, forKey: terminate3.params.sender)
        }
        invocations.record(invocation)
        actions.closure(for: functionName)?()
    }

    enum terminate3: String, _StringRawRepresentable {
      case name = "terminate3"
      enum params: String, _StringRawRepresentable {
        case sender = "terminate(_sender:Any?).sender"
      }
    }
}

class MockDataManger: NSObject, DataManaging {
    let invocations = _Invocations()
    let actions = _Actions()

    // MARK: - save<T: Keyable>

    func save<T: Keyable>(_ data: Data?, key: T) {
        let functionName = save1.name
        let invocation = _Invocation(name: functionName.rawValue)
        if let data = data {
            invocation.set(parameter: data, forKey: save1.params.data)
        }
        invocation.set(parameter: key, forKey: save1.params.key)
        invocations.record(invocation)
        actions.closure(for: functionName)?()
    }

    enum save1: String, _StringRawRepresentable {
      case name = "save1"
      enum params: String, _StringRawRepresentable {
        case data = "save<T:Keyable>(_data:Data?,key:T).data"
        case key = "save<T:Keyable>(_data:Data?,key:T).key"
      }
    }

    // MARK: - load<T: Keyable>

    func load<T: Keyable>(key: T) -> Result<Data> {
        let functionName = load2.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: key, forKey: load2.params.key)
        invocations.record(invocation)
        actions.closure(for: functionName)?()
        actions.set(defaultReturnValue: Result.success(Data()), for: functionName)
        return actions.returnValue(for: functionName) as! Result<Data>
    }

    enum load2: String, _StringRawRepresentable {
      case name = "load2"
      enum params: String, _StringRawRepresentable {
        case key = "load<T:Keyable>(key:T).key"
      }
    }
}

class MockEmailController: NSObject, EmailControlling {
    let invocations = _Invocations()
    let actions = _Actions()

    // MARK: - openMail

    func openMail(receipient: String, subject: String, body: String) -> Result<Void> {
        let functionName = openMail1.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: receipient, forKey: openMail1.params.receipient)
        invocation.set(parameter: subject, forKey: openMail1.params.subject)
        invocation.set(parameter: body, forKey: openMail1.params.body)
        invocations.record(invocation)
        actions.closure(for: functionName)?()
        return actions.returnValue(for: functionName) as! Result<Void>
    }

    enum openMail1: String, _StringRawRepresentable {
      case name = "openMail1"
      enum params: String, _StringRawRepresentable {
        case receipient = "openMail(receipient:String,subject:String,body:String).receipient"
        case subject = "openMail(receipient:String,subject:String,body:String).subject"
        case body = "openMail(receipient:String,subject:String,body:String).body"
      }
    }
}

class MockFileManager: NSObject, FileManaging {
    let invocations = _Invocations()
    let actions = _Actions()

    // MARK: - removeItem

    func removeItem(at URL: URL) throws {
        let functionName = removeItem1.name
        if let error = actions.error(for: functionName) {
            throw error
        }
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: URL, forKey: removeItem1.params.URL)
        invocations.record(invocation)
        actions.closure(for: functionName)?()
    }

    enum removeItem1: String, _StringRawRepresentable {
      case name = "removeItem1"
      enum params: String, _StringRawRepresentable {
        case URL = "removeItem(atURL:URL).URL"
      }
    }

    // MARK: - moveItem

    func moveItem(at srcURL: URL, to dstURL: URL) throws {
        let functionName = moveItem2.name
        if let error = actions.error(for: functionName) {
            throw error
        }
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: srcURL, forKey: moveItem2.params.srcURL)
        invocation.set(parameter: dstURL, forKey: moveItem2.params.dstURL)
        invocations.record(invocation)
        actions.closure(for: functionName)?()
    }

    enum moveItem2: String, _StringRawRepresentable {
      case name = "moveItem2"
      enum params: String, _StringRawRepresentable {
        case srcURL = "moveItem(atsrcURL:URL,todstURL:URL).srcURL"
        case dstURL = "moveItem(atsrcURL:URL,todstURL:URL).dstURL"
      }
    }

    // MARK: - createDirectory

    func createDirectory(at url: URL, withIntermediateDirectories createIntermediates: Bool, attributes: [FileAttributeKey: Any]?) throws {
        let functionName = createDirectory3.name
        if let error = actions.error(for: functionName) {
            throw error
        }
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: url, forKey: createDirectory3.params.url)
        invocation.set(parameter: createIntermediates, forKey: createDirectory3.params.createIntermediates)
        if let attributes = attributes {
            invocation.set(parameter: attributes, forKey: createDirectory3.params.attributes)
        }
        invocations.record(invocation)
        actions.closure(for: functionName)?()
    }

    enum createDirectory3: String, _StringRawRepresentable {
      case name = "createDirectory3"
      enum params: String, _StringRawRepresentable {
        case url = "createDirectory(aturl:URL,withIntermediateDirectoriescreateIntermediates:Bool,attributes:[FileAttributeKey:Any]?).url"
        case createIntermediates = "createDirectory(aturl:URL,withIntermediateDirectoriescreateIntermediates:Bool,attributes:[FileAttributeKey:Any]?).createIntermediates"
        case attributes = "createDirectory(aturl:URL,withIntermediateDirectoriescreateIntermediates:Bool,attributes:[FileAttributeKey:Any]?).attributes"
      }
    }

    // MARK: - fileExists

    func fileExists(atPath path: String) -> Bool {
        let functionName = fileExists4.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: path, forKey: fileExists4.params.path)
        invocations.record(invocation)
        actions.closure(for: functionName)?()
        actions.set(defaultReturnValue: true, for: functionName)
        return actions.returnValue(for: functionName) as! Bool
    }

    enum fileExists4: String, _StringRawRepresentable {
      case name = "fileExists4"
      enum params: String, _StringRawRepresentable {
        case path = "fileExists(atPathpath:String).path"
      }
    }
}

class MockLoadingStatusItem: NSObject, LoadingStatusItemable {
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
    var viewState: LoadingStatusItemViewState {
        get { return _viewState }
        set(value) { _viewState = value }
    }
    var _viewState: LoadingStatusItemViewState!
    var menu: Menuable?
    let invocations = _Invocations()
    let actions = _Actions()

    // MARK: - item<T: MenuItemable>

    func item<T: MenuItemable>(at index: Int) -> T? {
        let functionName = item1.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: index, forKey: item1.params.index)
        invocations.record(invocation)
        actions.closure(for: functionName)?()
        return actions.returnValue(for: functionName) as? T
    }

    enum item1: String, _StringRawRepresentable {
      case name = "item1"
      enum params: String, _StringRawRepresentable {
        case index = "item<T:MenuItemable>(atindex:Int).index"
      }
    }
}

class MockMenuItem: NSObject, MenuItemable {
    typealias DelegateType = Any
    typealias ActionType = Any
    var actionType: ActionType {
        get { return _actionType }
        set(value) { _actionType = value }
    }
    var _actionType: ActionType!
    var viewState: MenuItemViewState {
        get { return _viewState }
        set(value) { _viewState = value }
    }
    var _viewState: MenuItemViewState!
    let invocations = _Invocations()
    let actions = _Actions()

    // MARK: - setDelegate

    func setDelegate(_ delegate: DelegateType) {
        let functionName = setDelegate1.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: delegate, forKey: setDelegate1.params.delegate)
        invocations.record(invocation)
        actions.closure(for: functionName)?()
    }

    enum setDelegate1: String, _StringRawRepresentable {
      case name = "setDelegate1"
      enum params: String, _StringRawRepresentable {
        case delegate = "setDelegate(_delegate:DelegateType).delegate"
      }
    }
}

class MockMenu: NSObject, Menuable {
    var viewState: MenuViewState {
        get { return _viewState }
        set(value) { _viewState = value }
    }
    var _viewState: MenuViewState!
    let invocations = _Invocations()
    let actions = _Actions()

    // MARK: - item<T: MenuItemable>

    func item<T: MenuItemable>(at index: Int) -> T? {
        let functionName = item1.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: index, forKey: item1.params.index)
        invocations.record(invocation)
        actions.closure(for: functionName)?()
        return actions.returnValue(for: functionName) as? T
    }

    enum item1: String, _StringRawRepresentable {
      case name = "item1"
      enum params: String, _StringRawRepresentable {
        case index = "item<T:MenuItemable>(atindex:Int).index"
      }
    }
}

class MockNetworkManager: NSObject, NetworkManaging {
    let invocations = _Invocations()
    let actions = _Actions()

    // MARK: - fetch<T: Response>

    func fetch<T: Response>(request: Request, completion: @escaping (Result<T>) -> Void) {
        let functionName = fetch1.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: request, forKey: fetch1.params.request)
        invocation.set(parameter: completion, forKey: fetch1.params.completion)
        invocations.record(invocation)
        actions.closure(for: functionName)?()
    }

    enum fetch1: String, _StringRawRepresentable {
      case name = "fetch1"
      enum params: String, _StringRawRepresentable {
        case request = "fetch<T:Response>(request:Request,completion:@escaping(Result<T>)->Void).request"
        case completion = "fetch<T:Response>(request:Request,completion:@escaping(Result<T>)->Void).completion"
      }
    }

    // MARK: - download

    func download(_ url: URL, completion: @escaping (Result<URL>) -> Void) {
        let functionName = download2.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: url, forKey: download2.params.url)
        invocation.set(parameter: completion, forKey: download2.params.completion)
        invocations.record(invocation)
        actions.closure(for: functionName)?()
    }

    enum download2: String, _StringRawRepresentable {
      case name = "download2"
      enum params: String, _StringRawRepresentable {
        case url = "download(_url:URL,completion:@escaping(Result<URL>)->Void).url"
        case completion = "download(_url:URL,completion:@escaping(Result<URL>)->Void).completion"
      }
    }

    // MARK: - cancelAll

    func cancelAll() {
        let functionName = cancelAll3.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocations.record(invocation)
        actions.closure(for: functionName)?()
    }

    enum cancelAll3: String, _StringRawRepresentable {
      case name = "cancelAll3"
    }
}

class MockOperationQueue: NSObject, OperationQueable {
    let invocations = _Invocations()
    let actions = _Actions()

    // MARK: - addOperation

    func addOperation(_ op: Operation) {
        let functionName = addOperation1.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: op, forKey: addOperation1.params.op)
        invocations.record(invocation)
        actions.closure(for: functionName)?()
    }

    enum addOperation1: String, _StringRawRepresentable {
      case name = "addOperation1"
      enum params: String, _StringRawRepresentable {
        case op = "addOperation(_op:Operation).op"
      }
    }

    // MARK: - cancelAllOperations

    func cancelAllOperations() {
        let functionName = cancelAllOperations2.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocations.record(invocation)
        actions.closure(for: functionName)?()
    }

    enum cancelAllOperations2: String, _StringRawRepresentable {
      case name = "cancelAllOperations2"
    }
}

class MockPhotoAlbumService: NSObject, PhotoAlbumServicing {
    let invocations = _Invocations()
    let actions = _Actions()

    // MARK: - fetchPhotoAlbums

    func fetchPhotoAlbums(completion: @escaping (Result<[PhotoAlbumServiceFetchResult]>) -> Void) {
        let functionName = fetchPhotoAlbums1.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: completion, forKey: fetchPhotoAlbums1.params.completion)
        invocations.record(invocation)
        actions.closure(for: functionName)?()
    }

    enum fetchPhotoAlbums1: String, _StringRawRepresentable {
      case name = "fetchPhotoAlbums1"
      enum params: String, _StringRawRepresentable {
        case completion = "fetchPhotoAlbums(completion:@escaping(Result<[PhotoAlbumServiceFetchResult]>)->Void).completion"
      }
    }

    // MARK: - fetchPhotoResources

    func fetchPhotoResources(in album: PhotoAlbum, completion: @escaping (Result<[PhotoResource]>) -> Void) {
        let functionName = fetchPhotoResources2.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: album, forKey: fetchPhotoResources2.params.album)
        invocation.set(parameter: completion, forKey: fetchPhotoResources2.params.completion)
        invocations.record(invocation)
        actions.closure(for: functionName)?()
    }

    enum fetchPhotoResources2: String, _StringRawRepresentable {
      case name = "fetchPhotoResources2"
      enum params: String, _StringRawRepresentable {
        case album = "fetchPhotoResources(inalbum:PhotoAlbum,completion:@escaping(Result<[PhotoResource]>)->Void).album"
        case completion = "fetchPhotoResources(inalbum:PhotoAlbum,completion:@escaping(Result<[PhotoResource]>)->Void).completion"
      }
    }

    // MARK: - cancelAll

    func cancelAll() {
        let functionName = cancelAll3.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocations.record(invocation)
        actions.closure(for: functionName)?()
    }

    enum cancelAll3: String, _StringRawRepresentable {
      case name = "cancelAll3"
    }
}

class MockPhotoController: NSObject, PhotoControllable {
    var isDownloadInProgress: Bool {
        get { return _isDownloadInProgress }
        set(value) { _isDownloadInProgress = value }
    }
    var _isDownloadInProgress: Bool!
    var folderURL: URL {
        get { return _folderURL }
        set(value) { _folderURL = value }
    }
    var _folderURL: URL!
    let invocations = _Invocations()
    let actions = _Actions()

    // MARK: - setPreferences

    func setPreferences(_ preferences: Preferences) {
        let functionName = setPreferences1.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: preferences, forKey: setPreferences1.params.preferences)
        invocations.record(invocation)
        actions.closure(for: functionName)?()
    }

    enum setPreferences1: String, _StringRawRepresentable {
      case name = "setPreferences1"
      enum params: String, _StringRawRepresentable {
        case preferences = "setPreferences(_preferences:Preferences).preferences"
      }
    }

    // MARK: - reloadPhotos

    func reloadPhotos(completion: @escaping (Result<[PhotoControllerReloadResult]>) -> Void) {
        let functionName = reloadPhotos2.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: completion, forKey: reloadPhotos2.params.completion)
        invocations.record(invocation)
        actions.closure(for: functionName)?()
    }

    enum reloadPhotos2: String, _StringRawRepresentable {
      case name = "reloadPhotos2"
      enum params: String, _StringRawRepresentable {
        case completion = "reloadPhotos(completion:@escaping(Result<[PhotoControllerReloadResult]>)->Void).completion"
      }
    }

    // MARK: - cancelReload

    func cancelReload() -> Result<Void> {
        let functionName = cancelReload3.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocations.record(invocation)
        actions.closure(for: functionName)?()
        actions.set(defaultReturnValue: Result.success(()), for: functionName)
        return actions.returnValue(for: functionName) as! Result<Void>
    }

    enum cancelReload3: String, _StringRawRepresentable {
      case name = "cancelReload3"
    }

    // MARK: - clearFolder

    func clearFolder() -> Result<Void> {
        let functionName = clearFolder4.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocations.record(invocation)
        actions.closure(for: functionName)?()
        return actions.returnValue(for: functionName) as! Result<Void>
    }

    enum clearFolder4: String, _StringRawRepresentable {
      case name = "clearFolder4"
    }

    // MARK: - setDelegate

    func setDelegate(_ delegate: PhotoControllerDelegate) {
        let functionName = setDelegate5.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: delegate, forKey: setDelegate5.params.delegate)
        invocations.record(invocation)
        actions.closure(for: functionName)?()
    }

    enum setDelegate5: String, _StringRawRepresentable {
      case name = "setDelegate5"
      enum params: String, _StringRawRepresentable {
        case delegate = "setDelegate(_delegate:PhotoControllerDelegate).delegate"
      }
    }
}

class MockPhotoControllerDelegate: NSObject, PhotoControllerDelegate {
    let invocations = _Invocations()
    let actions = _Actions()

    // MARK: - photoControllerTimerTriggered

    func photoControllerTimerTriggered(_ photoController: PhotoController) {
        let functionName = photoControllerTimerTriggered1.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: photoController, forKey: photoControllerTimerTriggered1.params.photoController)
        invocations.record(invocation)
        actions.closure(for: functionName)?()
    }

    enum photoControllerTimerTriggered1: String, _StringRawRepresentable {
      case name = "photoControllerTimerTriggered1"
      enum params: String, _StringRawRepresentable {
        case photoController = "photoControllerTimerTriggered(_photoController:PhotoController).photoController"
      }
    }

    // MARK: - photoController

    func photoController(_ photoController: PhotoController, updatedDownloadPercentage percentage: Double) {
        let functionName = photoController2.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: photoController, forKey: photoController2.params.photoController)
        invocation.set(parameter: percentage, forKey: photoController2.params.percentage)
        invocations.record(invocation)
        actions.closure(for: functionName)?()
    }

    enum photoController2: String, _StringRawRepresentable {
      case name = "photoController2"
      enum params: String, _StringRawRepresentable {
        case photoController = "photoController(_photoController:PhotoController,updatedDownloadPercentagepercentage:Double).photoController"
        case percentage = "photoController(_photoController:PhotoController,updatedDownloadPercentagepercentage:Double).percentage"
      }
    }

    // MARK: - photoController

    func photoController(_ photoController: PhotoController, didChangeDownloadState inProgress: Bool) {
        let functionName = photoController3.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: photoController, forKey: photoController3.params.photoController)
        invocation.set(parameter: inProgress, forKey: photoController3.params.inProgress)
        invocations.record(invocation)
        actions.closure(for: functionName)?()
    }

    enum photoController3: String, _StringRawRepresentable {
      case name = "photoController3"
      enum params: String, _StringRawRepresentable {
        case photoController = "photoController(_photoController:PhotoController,didChangeDownloadStateinProgress:Bool).photoController"
        case inProgress = "photoController(_photoController:PhotoController,didChangeDownloadStateinProgress:Bool).inProgress"
      }
    }
}

class MockPhotoService: NSObject, PhotoServicing {
    var saveURL: URL {
        get { return _saveURL }
        set(value) { _saveURL = value }
    }
    var _saveURL: URL!
    let invocations = _Invocations()
    let actions = _Actions()

    // MARK: - downloadPhoto

    func downloadPhoto(_ resource: PhotoResource, completion: @escaping (Result<PhotoResource>) -> Void) {
        let functionName = downloadPhoto1.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: resource, forKey: downloadPhoto1.params.resource)
        invocation.set(parameter: completion, forKey: downloadPhoto1.params.completion)
        invocations.record(invocation)
        actions.closure(for: functionName)?()
    }

    enum downloadPhoto1: String, _StringRawRepresentable {
      case name = "downloadPhoto1"
      enum params: String, _StringRawRepresentable {
        case resource = "downloadPhoto(_resource:PhotoResource,completion:@escaping(Result<PhotoResource>)->Void).resource"
        case completion = "downloadPhoto(_resource:PhotoResource,completion:@escaping(Result<PhotoResource>)->Void).completion"
      }
    }

    // MARK: - cancelAll

    func cancelAll() {
        let functionName = cancelAll2.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocations.record(invocation)
        actions.closure(for: functionName)?()
    }

    enum cancelAll2: String, _StringRawRepresentable {
      case name = "cancelAll2"
    }
}

class MockPhotoStorageService: NSObject, PhotoStorageServicing {
    let invocations = _Invocations()
    let actions = _Actions()

    // MARK: - save

    func save(_ resources: [PhotoResource]) -> Result<Void> {
        let functionName = save1.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: resources, forKey: save1.params.resources)
        invocations.record(invocation)
        actions.closure(for: functionName)?()
        actions.set(defaultReturnValue: Result.success(()), for: functionName)
        return actions.returnValue(for: functionName) as! Result<Void>
    }

    enum save1: String, _StringRawRepresentable {
      case name = "save1"
      enum params: String, _StringRawRepresentable {
        case resources = "save(_resources:[PhotoResource]).resources"
      }
    }

    // MARK: - load

    func load() -> Result<[PhotoResource]> {
        let functionName = load2.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocations.record(invocation)
        actions.closure(for: functionName)?()
        actions.set(defaultReturnValue: Result.success([PhotoResource]()), for: functionName)
        return actions.returnValue(for: functionName) as! Result<[PhotoResource]>
    }

    enum load2: String, _StringRawRepresentable {
      case name = "load2"
    }

    // MARK: - remove

    func remove(_ resources: [PhotoResource]) -> Result<[PhotoStorageServiceDeletionResult]> {
        let functionName = remove3.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: resources, forKey: remove3.params.resources)
        invocations.record(invocation)
        actions.closure(for: functionName)?()
        actions.set(defaultReturnValue: Result.success([PhotoStorageServiceDeletionResult]()), for: functionName)
        return actions.returnValue(for: functionName) as! Result<[PhotoStorageServiceDeletionResult]>
    }

    enum remove3: String, _StringRawRepresentable {
      case name = "remove3"
      enum params: String, _StringRawRepresentable {
        case resources = "remove(_resources:[PhotoResource]).resources"
      }
    }
}

class MockPreferencesController: NSObject, PreferencesControllable {
    var preferences: Preferences {
        get { return _preferences }
        set(value) { _preferences = value }
    }
    var _preferences: Preferences! = Preferences()
    let invocations = _Invocations()
    let actions = _Actions()

    // MARK: - open

    func open() {
        let functionName = open1.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocations.record(invocation)
        actions.closure(for: functionName)?()
    }

    enum open1: String, _StringRawRepresentable {
      case name = "open1"
    }

    // MARK: - setDelegate

    func setDelegate(_ delegate: PreferencesControllerDelegate) {
        let functionName = setDelegate2.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: delegate, forKey: setDelegate2.params.delegate)
        invocations.record(invocation)
        actions.closure(for: functionName)?()
    }

    enum setDelegate2: String, _StringRawRepresentable {
      case name = "setDelegate2"
      enum params: String, _StringRawRepresentable {
        case delegate = "setDelegate(_delegate:PreferencesControllerDelegate).delegate"
      }
    }
}

class MockPreferencesService: NSObject, PreferencesServicing {
    let invocations = _Invocations()
    let actions = _Actions()

    // MARK: - save

    func save(_ preferences: Preferences) -> Result<Void> {
        let functionName = save1.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: preferences, forKey: save1.params.preferences)
        invocations.record(invocation)
        actions.closure(for: functionName)?()
        actions.set(defaultReturnValue: Result.success(()), for: functionName)
        return actions.returnValue(for: functionName) as! Result<Void>
    }

    enum save1: String, _StringRawRepresentable {
      case name = "save1"
      enum params: String, _StringRawRepresentable {
        case preferences = "save(_preferences:Preferences).preferences"
      }
    }

    // MARK: - load

    func load() -> Result<Preferences> {
        let functionName = load2.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocations.record(invocation)
        actions.closure(for: functionName)?()
        actions.set(defaultReturnValue: Result.success(Preferences()), for: functionName)
        return actions.returnValue(for: functionName) as! Result<Preferences>
    }

    enum load2: String, _StringRawRepresentable {
      case name = "load2"
    }
}

class MockPreferencesViewController: NSViewController, PreferencesViewControllable {
    var viewState: PreferencesViewState?
    let invocations = _Invocations()
    let actions = _Actions()

    // MARK: - setViewState

    func setViewState(_ viewState: PreferencesViewState) {
        let functionName = setViewState1.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: viewState, forKey: setViewState1.params.viewState)
        invocations.record(invocation)
        actions.closure(for: functionName)?()
    }

    enum setViewState1: String, _StringRawRepresentable {
      case name = "setViewState1"
      enum params: String, _StringRawRepresentable {
        case viewState = "setViewState(_viewState:PreferencesViewState).viewState"
      }
    }

    // MARK: - setDelegate

    func setDelegate(_ delegate: PreferencesViewControllerDelegate) {
        let functionName = setDelegate2.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: delegate, forKey: setDelegate2.params.delegate)
        invocations.record(invocation)
        actions.closure(for: functionName)?()
    }

    enum setDelegate2: String, _StringRawRepresentable {
      case name = "setDelegate2"
      enum params: String, _StringRawRepresentable {
        case delegate = "setDelegate(_delegate:PreferencesViewControllerDelegate).delegate"
      }
    }
}

class MockReachability: NSObject, Reachable {
    var isReachable: Bool {
        get { return _isReachable }
        set(value) { _isReachable = value }
    }
    var _isReachable: Bool!
    let invocations = _Invocations()
    let actions = _Actions()

    // MARK: - setDelegate

    func setDelegate(_ delegate: ReachabilityDelegate) {
        let functionName = setDelegate1.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: delegate, forKey: setDelegate1.params.delegate)
        invocations.record(invocation)
        actions.closure(for: functionName)?()
    }

    enum setDelegate1: String, _StringRawRepresentable {
      case name = "setDelegate1"
      enum params: String, _StringRawRepresentable {
        case delegate = "setDelegate(_delegate:ReachabilityDelegate).delegate"
      }
    }
}

class MockSharingService: NSObject, SharingServicing {
    var subject: String?
    var recipients: [String]?
    var messageBody: String?
    let invocations = _Invocations()
    let actions = _Actions()

    // MARK: - canPerform

    func canPerform(withItems items: [Any]?) -> Bool {
        let functionName = canPerform1.name
        let invocation = _Invocation(name: functionName.rawValue)
        if let items = items {
            invocation.set(parameter: items, forKey: canPerform1.params.items)
        }
        invocations.record(invocation)
        actions.closure(for: functionName)?()
        return actions.returnValue(for: functionName) as! Bool
    }

    enum canPerform1: String, _StringRawRepresentable {
      case name = "canPerform1"
      enum params: String, _StringRawRepresentable {
        case items = "canPerform(withItemsitems:[Any]?).items"
      }
    }

    // MARK: - perform

    func perform(withItems items: [Any]) {
        let functionName = perform2.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: items, forKey: perform2.params.items)
        invocations.record(invocation)
        actions.closure(for: functionName)?()
    }

    enum perform2: String, _StringRawRepresentable {
      case name = "perform2"
      enum params: String, _StringRawRepresentable {
        case items = "perform(withItemsitems:[Any]).items"
      }
    }
}

class MockURLSession: NSObject, URLSessioning {
    let invocations = _Invocations()
    let actions = _Actions()

    // MARK: - dataTask

    func dataTask(with url: URL,completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let functionName = dataTask1.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: url, forKey: dataTask1.params.url)
        invocation.set(parameter: completionHandler, forKey: dataTask1.params.completionHandler)
        invocations.record(invocation)
        actions.closure(for: functionName)?()
        return actions.returnValue(for: functionName) as! URLSessionDataTask
    }

    enum dataTask1: String, _StringRawRepresentable {
      case name = "dataTask1"
      enum params: String, _StringRawRepresentable {
        case url = "dataTask(withurl:URL,completionHandler:@escaping(Data?,URLResponse?,Error?)->Void).url"
        case completionHandler = "dataTask(withurl:URL,completionHandler:@escaping(Data?,URLResponse?,Error?)->Void).completionHandler"
      }
    }

    // MARK: - downloadTask

    func downloadTask(with url: URL,completionHandler: @escaping (URL?, URLResponse?, Error?) -> Void) -> URLSessionDownloadTask {
        let functionName = downloadTask2.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: url, forKey: downloadTask2.params.url)
        invocation.set(parameter: completionHandler, forKey: downloadTask2.params.completionHandler)
        invocations.record(invocation)
        actions.closure(for: functionName)?()
        return actions.returnValue(for: functionName) as! URLSessionDownloadTask
    }

    enum downloadTask2: String, _StringRawRepresentable {
      case name = "downloadTask2"
      enum params: String, _StringRawRepresentable {
        case url = "downloadTask(withurl:URL,completionHandler:@escaping(URL?,URLResponse?,Error?)->Void).url"
        case completionHandler = "downloadTask(withurl:URL,completionHandler:@escaping(URL?,URLResponse?,Error?)->Void).completionHandler"
      }
    }
}

class MockUserDefaults: NSObject, UserDefaultable {
    let invocations = _Invocations()
    let actions = _Actions()

    // MARK: - object

    func object(forKey defaultName: String) -> Any? {
        let functionName = object1.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: defaultName, forKey: object1.params.defaultName)
        invocations.record(invocation)
        actions.closure(for: functionName)?()
        return actions.returnValue(for: functionName) as Any
    }

    enum object1: String, _StringRawRepresentable {
      case name = "object1"
      enum params: String, _StringRawRepresentable {
        case defaultName = "object(forKeydefaultName:String).defaultName"
      }
    }

    // MARK: - set

    func set(_ value: Any?, forKey defaultName: String) {
        let functionName = set2.name
        let invocation = _Invocation(name: functionName.rawValue)
        if let value = value {
            invocation.set(parameter: value, forKey: set2.params.value)
        }
        invocation.set(parameter: defaultName, forKey: set2.params.defaultName)
        invocations.record(invocation)
        actions.closure(for: functionName)?()
    }

    enum set2: String, _StringRawRepresentable {
      case name = "set2"
      enum params: String, _StringRawRepresentable {
        case value = "set(_value:Any?,forKeydefaultName:String).value"
        case defaultName = "set(_value:Any?,forKeydefaultName:String).defaultName"
      }
    }
}

class MockWindowController: NSObject, WindowControlling {
    var contentViewController: NSViewController?
    let invocations = _Invocations()
    let actions = _Actions()

    // MARK: - showWindow

    func showWindow(_ sender: Any?) {
        let functionName = showWindow1.name
        let invocation = _Invocation(name: functionName.rawValue)
        if let sender = sender {
            invocation.set(parameter: sender, forKey: showWindow1.params.sender)
        }
        invocations.record(invocation)
        actions.closure(for: functionName)?()
    }

    enum showWindow1: String, _StringRawRepresentable {
      case name = "showWindow1"
      enum params: String, _StringRawRepresentable {
        case sender = "showWindow(_sender:Any?).sender"
      }
    }
}

class MockWorkspaceController: NSObject, WorkspaceControllable {
    let invocations = _Invocations()
    let actions = _Actions()

    // MARK: - open

    func open(_ preference: SystemPreference) -> Result<Void> {
        let functionName = open1.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: preference, forKey: open1.params.preference)
        invocations.record(invocation)
        actions.closure(for: functionName)?()
        return actions.returnValue(for: functionName) as! Result<Void>
    }

    enum open1: String, _StringRawRepresentable {
      case name = "open1"
      enum params: String, _StringRawRepresentable {
        case preference = "open(_preference:SystemPreference).preference"
      }
    }

    // MARK: - open

    func open(_ url: URL) -> Result<Void> {
        let functionName = open2.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: url, forKey: open2.params.url)
        invocations.record(invocation)
        actions.closure(for: functionName)?()
        return actions.returnValue(for: functionName) as! Result<Void>
    }

    enum open2: String, _StringRawRepresentable {
      case name = "open2"
      enum params: String, _StringRawRepresentable {
        case url = "open(_url:URL).url"
      }
    }
}

class MockWorkspace: NSObject, Workspacing {
    let invocations = _Invocations()
    let actions = _Actions()

    // MARK: - open

    func open(_ url: URL) -> Bool {
        let functionName = open1.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: url, forKey: open1.params.url)
        invocations.record(invocation)
        actions.closure(for: functionName)?()
        actions.set(defaultReturnValue: true, for: functionName)
        return actions.returnValue(for: functionName) as! Bool
    }

    enum open1: String, _StringRawRepresentable {
      case name = "open1"
      enum params: String, _StringRawRepresentable {
        case url = "open(_url:URL).url"
      }
    }
}
