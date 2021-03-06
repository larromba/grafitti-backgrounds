// Generated using Sourcery 0.18.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// swiftlint:disable line_length
// swiftlint:disable variable_name

// https://github.com/larromba/swift-mockable 
// 2.0.0

import Foundation
#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

import AsyncAwait
@testable import Graffiti_Backgrounds

// MARK: - Sourcery Helper

protocol _StringRawRepresentable: RawRepresentable {
    var rawValue: String { get }
}

struct _Variable<T> {
    let date = Date()
    var variable: T?

    init(_ variable: T?) {
        self.variable = variable
    }
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
        case returnValue
        case defaultReturnValue
        case error
    }
    private var invocations: [_Invocation] = []

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
        return history.filter { $0.name == name.rawValue }.count
    }

    func all() -> [_Invocation] {
        return history.sorted { $0.date < $1.date }
    }

    func find<T: _StringRawRepresentable>(_ name: T) -> [_Invocation] {
        return history.filter { $0.name == name.rawValue }.sorted { $0.date < $1.date }
    }

    func clear() {
        history.removeAll()
    }
}

// MARK: - Sourcery Mocks

class MockAlertController: NSObject, AlertControlling {
    let invocations = _Invocations()
    let actions = _Actions()
    static let invocations = _Invocations()
    static let actions = _Actions()

    // MARK: - showAlert

    func showAlert(_ alert: Alert) {
        let functionName = showAlert1.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: alert, forKey: showAlert1.params.alert)
        invocations.record(invocation)
    }

    enum showAlert1: String, _StringRawRepresentable {
        case name = "showAlert1"
        enum params: String, _StringRawRepresentable {
            case alert = "showAlert(_alert:Alert).alert"
        }
    }
}

class MockAppController: NSObject, AppCoordinating {
    let invocations = _Invocations()
    let actions = _Actions()
    static let invocations = _Invocations()
    static let actions = _Actions()

    // MARK: - start

    func start() {
        let functionName = start1.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocations.record(invocation)
    }

    enum start1: String, _StringRawRepresentable {
        case name = "start1"
    }

    // MARK: - setDelegate

    func setDelegate(_ delegate: AppCoordinatorDelegate) {
        let functionName = setDelegate2.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: delegate, forKey: setDelegate2.params.delegate)
        invocations.record(invocation)
    }

    enum setDelegate2: String, _StringRawRepresentable {
        case name = "setDelegate2"
        enum params: String, _StringRawRepresentable {
            case delegate = "setDelegate(_delegate:AppCoordinatorDelegate).delegate"
        }
    }
}

class MockAppDelegate: NSObject, AppDelegatable {
}

class MockAppMenuController: NSObject, AppMenuControllable {
    let invocations = _Invocations()
    let actions = _Actions()
    static let invocations = _Invocations()
    static let actions = _Actions()

    // MARK: - setLoadingPercentage

    func setLoadingPercentage(_ percentage: Double) {
        let functionName = setLoadingPercentage1.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: percentage, forKey: setLoadingPercentage1.params.percentage)
        invocations.record(invocation)
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
    }

    enum setDelegate4: String, _StringRawRepresentable {
        case name = "setDelegate4"
        enum params: String, _StringRawRepresentable {
            case delegate = "setDelegate(_delegate:AppMenuControllerDelegate).delegate"
        }
    }
}

class MockAppRouter: NSObject, AppRouting {
    let invocations = _Invocations()
    let actions = _Actions()
    static let invocations = _Invocations()
    static let actions = _Actions()

    // MARK: - start

    func start() {
        let functionName = start1.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocations.record(invocation)
    }

    enum start1: String, _StringRawRepresentable {
        case name = "start1"
    }

    // MARK: - setDelegate

    func setDelegate(_ delegate: AppRouterDelegate) {
        let functionName = setDelegate2.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: delegate, forKey: setDelegate2.params.delegate)
        invocations.record(invocation)
    }

    enum setDelegate2: String, _StringRawRepresentable {
        case name = "setDelegate2"
        enum params: String, _StringRawRepresentable {
            case delegate = "setDelegate(_delegate:AppRouterDelegate).delegate"
        }
    }
}

class MockApp: NSObject, Apping {
    let invocations = _Invocations()
    let actions = _Actions()
    static let invocations = _Invocations()
    static let actions = _Actions()

    // MARK: - start

    func start() {
        let functionName = start1.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocations.record(invocation)
    }

    enum start1: String, _StringRawRepresentable {
        case name = "start1"
    }
}

class MockApplication: NSObject, Applicationable {
    let invocations = _Invocations()
    let actions = _Actions()
    static let invocations = _Invocations()
    static let actions = _Actions()

    // MARK: - activate

    func activate(ignoringOtherApps flag: Bool) {
        let functionName = activate1.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: flag, forKey: activate1.params.flag)
        invocations.record(invocation)
    }

    enum activate1: String, _StringRawRepresentable {
        case name = "activate1"
        enum params: String, _StringRawRepresentable {
            case flag = "activate(ignoringOtherAppsflag:Bool).flag"
        }
    }

    // MARK: - orderFrontStandardAboutPanel

    func orderFrontStandardAboutPanel(_ sender: Any?) {
        let functionName = orderFrontStandardAboutPanel2.name
        let invocation = _Invocation(name: functionName.rawValue)
        if let sender = sender {
            invocation.set(parameter: sender, forKey: orderFrontStandardAboutPanel2.params.sender)
        }
        invocations.record(invocation)
    }

    enum orderFrontStandardAboutPanel2: String, _StringRawRepresentable {
        case name = "orderFrontStandardAboutPanel2"
        enum params: String, _StringRawRepresentable {
            case sender = "orderFrontStandardAboutPanel(_sender:Any?).sender"
        }
    }

    // MARK: - orderFrontStandardAboutPanel

    func orderFrontStandardAboutPanel(options optionsDictionary: [NSApplication.AboutPanelOptionKey: Any]) {
        let functionName = orderFrontStandardAboutPanel3.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: optionsDictionary, forKey: orderFrontStandardAboutPanel3.params.optionsDictionary)
        invocations.record(invocation)
    }

    enum orderFrontStandardAboutPanel3: String, _StringRawRepresentable {
        case name = "orderFrontStandardAboutPanel3"
        enum params: String, _StringRawRepresentable {
            case optionsDictionary = "orderFrontStandardAboutPanel(optionsoptionsDictionary:[NSApplication.AboutPanelOptionKey:Any]).optionsDictionary"
        }
    }

    // MARK: - terminate

    func terminate(_ sender: Any?) {
        let functionName = terminate4.name
        let invocation = _Invocation(name: functionName.rawValue)
        if let sender = sender {
            invocation.set(parameter: sender, forKey: terminate4.params.sender)
        }
        invocations.record(invocation)
    }

    enum terminate4: String, _StringRawRepresentable {
        case name = "terminate4"
        enum params: String, _StringRawRepresentable {
            case sender = "terminate(_sender:Any?).sender"
        }
    }
}

class MockDataManger: NSObject, DataManaging {
    let invocations = _Invocations()
    let actions = _Actions()
    static let invocations = _Invocations()
    static let actions = _Actions()

    // MARK: - save<T: Keyable>

    func save<T: Keyable>(_ data: Data?, key: T) {
        let functionName = save1.name
        let invocation = _Invocation(name: functionName.rawValue)
        if let data = data {
            invocation.set(parameter: data, forKey: save1.params.data)
        }
        invocation.set(parameter: key, forKey: save1.params.key)
        invocations.record(invocation)
    }

    enum save1: String, _StringRawRepresentable {
        case name = "save1"
        enum params: String, _StringRawRepresentable {
            case data = "save<T:Keyable>(_data:Data?,key:T).data"
            case key = "save<T:Keyable>(_data:Data?,key:T).key"
        }
    }

    // MARK: - load<T: Keyable>

    func load<T: Keyable>(key: T) -> Data? {
        let functionName = load2.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: key, forKey: load2.params.key)
        invocations.record(invocation)
        return actions.returnValue(for: functionName) as? Data
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
    static let invocations = _Invocations()
    static let actions = _Actions()

    // MARK: - openMail

    func openMail(receipient: String, subject: String, body: String) -> Result<Void, EmailError> {
        let functionName = openMail1.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: receipient, forKey: openMail1.params.receipient)
        invocation.set(parameter: subject, forKey: openMail1.params.subject)
        invocation.set(parameter: body, forKey: openMail1.params.body)
        invocations.record(invocation)
        return actions.returnValue(for: functionName) as! Result<Void, EmailError>
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
    static let invocations = _Invocations()
    static let actions = _Actions()

    // MARK: - removeItem

    func removeItem(at URL: URL) throws {
        let functionName = removeItem1.name
        if let error = actions.error(for: functionName) {
            throw error
        }
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: URL, forKey: removeItem1.params.URL)
        invocations.record(invocation)
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
    var viewState: LoadingStatusItemViewStating {
        get { return _viewState }
        set(value) { _viewState = value; _viewStateHistory.append(_Variable(value)) }
    }
    var _viewState: LoadingStatusItemViewStating!
    var _viewStateHistory: [_Variable<LoadingStatusItemViewStating?>] = []
    var menu: Menuable? {
        get { return _menu }
        set(value) { _menu = value; _menuHistory.append(_Variable(value)) }
    }
    var _menu: Menuable? = MockMenu()
    var _menuHistory: [_Variable<Menuable?>] = []
    let invocations = _Invocations()
    let actions = _Actions()
    static let invocations = _Invocations()
    static let actions = _Actions()

    // MARK: - item<T: MenuItemable>

    func item<T: MenuItemable>(at index: Int) -> T? {
        let functionName = item1.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: index, forKey: item1.params.index)
        invocations.record(invocation)
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
        set(value) { _actionType = value; _actionTypeHistory.append(_Variable(value)) }
    }
    var _actionType: ActionType!
    var _actionTypeHistory: [_Variable<ActionType?>] = []
    var viewState: MenuItemViewStating {
        get { return _viewState }
        set(value) { _viewState = value; _viewStateHistory.append(_Variable(value)) }
    }
    var _viewState: MenuItemViewStating!
    var _viewStateHistory: [_Variable<MenuItemViewStating?>] = []
    let invocations = _Invocations()
    let actions = _Actions()
    static let invocations = _Invocations()
    static let actions = _Actions()

    // MARK: - setDelegate

    func setDelegate(_ delegate: DelegateType) {
        let functionName = setDelegate1.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: delegate, forKey: setDelegate1.params.delegate)
        invocations.record(invocation)
    }

    enum setDelegate1: String, _StringRawRepresentable {
        case name = "setDelegate1"
        enum params: String, _StringRawRepresentable {
            case delegate = "setDelegate(_delegate:DelegateType).delegate"
        }
    }
}

class MockMenu: NSObject, Menuable {
    var viewState: MenuViewStating {
        get { return _viewState }
        set(value) { _viewState = value; _viewStateHistory.append(_Variable(value)) }
    }
    var _viewState: MenuViewStating!
    var _viewStateHistory: [_Variable<MenuViewStating?>] = []
    let invocations = _Invocations()
    let actions = _Actions()
    static let invocations = _Invocations()
    static let actions = _Actions()

    // MARK: - item<T: MenuItemable>

    func item<T: MenuItemable>(at index: Int) -> T? {
        let functionName = item1.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: index, forKey: item1.params.index)
        invocations.record(invocation)
        return actions.returnValue(for: functionName) as? T
    }

    enum item1: String, _StringRawRepresentable {
        case name = "item1"
        enum params: String, _StringRawRepresentable {
            case index = "item<T:MenuItemable>(atindex:Int).index"
        }
    }
}

class MockPhotoAlbumService: NSObject, PhotoAlbumServicing {
    let invocations = _Invocations()
    let actions = _Actions()
    static let invocations = _Invocations()
    static let actions = _Actions()

    // MARK: - fetchPhotoAlbums

    func fetchPhotoAlbums(progress: @escaping (Double) -> Void) -> Async<[PhotoAlbum], Error> {
        let functionName = fetchPhotoAlbums1.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: progress, forKey: fetchPhotoAlbums1.params.progress)
        invocations.record(invocation)
        return actions.returnValue(for: functionName) as! Async<[PhotoAlbum], Error>
    }

    enum fetchPhotoAlbums1: String, _StringRawRepresentable {
        case name = "fetchPhotoAlbums1"
        enum params: String, _StringRawRepresentable {
            case progress = "fetchPhotoAlbums(progress:@escaping(Double)->Void).progress"
        }
    }

    // MARK: - cancelAll

    func cancelAll() {
        let functionName = cancelAll2.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocations.record(invocation)
    }

    enum cancelAll2: String, _StringRawRepresentable {
        case name = "cancelAll2"
    }
}

class MockPhotoManagerDelegate: NSObject, PhotoManagerDelegate {
    let invocations = _Invocations()
    let actions = _Actions()
    static let invocations = _Invocations()
    static let actions = _Actions()

    // MARK: - photoManagerTimerTriggered

    func photoManagerTimerTriggered(_ photoManager: PhotoManaging) {
        let functionName = photoManagerTimerTriggered1.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: photoManager, forKey: photoManagerTimerTriggered1.params.photoManager)
        invocations.record(invocation)
    }

    enum photoManagerTimerTriggered1: String, _StringRawRepresentable {
        case name = "photoManagerTimerTriggered1"
        enum params: String, _StringRawRepresentable {
            case photoManager = "photoManagerTimerTriggered(_photoManager:PhotoManaging).photoManager"
        }
    }

    // MARK: - photoManager

    func photoManager(_ photoManager: PhotoManaging, updatedDownloadPercentage percentage: Double) {
        let functionName = photoManager2.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: photoManager, forKey: photoManager2.params.photoManager)
        invocation.set(parameter: percentage, forKey: photoManager2.params.percentage)
        invocations.record(invocation)
    }

    enum photoManager2: String, _StringRawRepresentable {
        case name = "photoManager2"
        enum params: String, _StringRawRepresentable {
            case photoManager = "photoManager(_photoManager:PhotoManaging,updatedDownloadPercentagepercentage:Double).photoManager"
            case percentage = "photoManager(_photoManager:PhotoManaging,updatedDownloadPercentagepercentage:Double).percentage"
        }
    }

    // MARK: - photoManager

    func photoManager(_ photoManager: PhotoManaging, didChangeDownloadState inProgress: Bool) {
        let functionName = photoManager3.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: photoManager, forKey: photoManager3.params.photoManager)
        invocation.set(parameter: inProgress, forKey: photoManager3.params.inProgress)
        invocations.record(invocation)
    }

    enum photoManager3: String, _StringRawRepresentable {
        case name = "photoManager3"
        enum params: String, _StringRawRepresentable {
            case photoManager = "photoManager(_photoManager:PhotoManaging,didChangeDownloadStateinProgress:Bool).photoManager"
            case inProgress = "photoManager(_photoManager:PhotoManaging,didChangeDownloadStateinProgress:Bool).inProgress"
        }
    }
}

class MockPhotoManager: NSObject, PhotoManaging {
    var isDownloadInProgress: Bool {
        get { return _isDownloadInProgress }
        set(value) { _isDownloadInProgress = value; _isDownloadInProgressHistory.append(_Variable(value)) }
    }
    var _isDownloadInProgress: Bool!
    var _isDownloadInProgressHistory: [_Variable<Bool?>] = []
    var photoFolderURL: URL {
        get { return _photoFolderURL }
        set(value) { _photoFolderURL = value; _photoFolderURLHistory.append(_Variable(value)) }
    }
    var _photoFolderURL: URL!
    var _photoFolderURLHistory: [_Variable<URL?>] = []
    let invocations = _Invocations()
    let actions = _Actions()
    static let invocations = _Invocations()
    static let actions = _Actions()

    // MARK: - setPreferences

    func setPreferences(_ preferences: Preferences) {
        let functionName = setPreferences1.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: preferences, forKey: setPreferences1.params.preferences)
        invocations.record(invocation)
    }

    enum setPreferences1: String, _StringRawRepresentable {
        case name = "setPreferences1"
        enum params: String, _StringRawRepresentable {
            case preferences = "setPreferences(_preferences:Preferences).preferences"
        }
    }

    // MARK: - reloadPhotos

    func reloadPhotos() -> Async<[PhotoResource], Error> {
        let functionName = reloadPhotos2.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocations.record(invocation)
        return actions.returnValue(for: functionName) as! Async<[PhotoResource], Error>
    }

    enum reloadPhotos2: String, _StringRawRepresentable {
        case name = "reloadPhotos2"
    }

    // MARK: - cancelReload

    func cancelReload() {
        let functionName = cancelReload3.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocations.record(invocation)
    }

    enum cancelReload3: String, _StringRawRepresentable {
        case name = "cancelReload3"
    }

    // MARK: - clearFolder

    func clearFolder() -> Result<Void, PhotoStorageError> {
        let functionName = clearFolder4.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocations.record(invocation)
        return actions.returnValue(for: functionName) as! Result<Void, PhotoStorageError>
    }

    enum clearFolder4: String, _StringRawRepresentable {
        case name = "clearFolder4"
    }

    // MARK: - setDelegate

    func setDelegate(_ delegate: PhotoManagerDelegate) {
        let functionName = setDelegate5.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: delegate, forKey: setDelegate5.params.delegate)
        invocations.record(invocation)
    }

    enum setDelegate5: String, _StringRawRepresentable {
        case name = "setDelegate5"
        enum params: String, _StringRawRepresentable {
            case delegate = "setDelegate(_delegate:PhotoManagerDelegate).delegate"
        }
    }
}

class MockPhotoService: NSObject, PhotoServicing {
    let invocations = _Invocations()
    let actions = _Actions()
    static let invocations = _Invocations()
    static let actions = _Actions()

    // MARK: - downloadPhotos

    func downloadPhotos(_ resources: [PhotoResource],progress: @escaping (Double) -> Void) -> Async<[PhotoResource], Error> {
        let functionName = downloadPhotos1.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: resources, forKey: downloadPhotos1.params.resources)
        invocation.set(parameter: progress, forKey: downloadPhotos1.params.progress)
        invocations.record(invocation)
        return actions.returnValue(for: functionName) as! Async<[PhotoResource], Error>
    }

    enum downloadPhotos1: String, _StringRawRepresentable {
        case name = "downloadPhotos1"
        enum params: String, _StringRawRepresentable {
            case resources = "downloadPhotos(_resources:[PhotoResource],progress:@escaping(Double)->Void).resources"
            case progress = "downloadPhotos(_resources:[PhotoResource],progress:@escaping(Double)->Void).progress"
        }
    }

    // MARK: - movePhotos

    func movePhotos(_ resources: [PhotoResource], toFolder url: URL) -> Result<[PhotoResource], PhotoServiceError> {
        let functionName = movePhotos2.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: resources, forKey: movePhotos2.params.resources)
        invocation.set(parameter: url, forKey: movePhotos2.params.url)
        invocations.record(invocation)
        return actions.returnValue(for: functionName) as! Result<[PhotoResource], PhotoServiceError>
    }

    enum movePhotos2: String, _StringRawRepresentable {
        case name = "movePhotos2"
        enum params: String, _StringRawRepresentable {
            case resources = "movePhotos(_resources:[PhotoResource],toFolderurl:URL).resources"
            case url = "movePhotos(_resources:[PhotoResource],toFolderurl:URL).url"
        }
    }

    // MARK: - cancelAll

    func cancelAll() {
        let functionName = cancelAll3.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocations.record(invocation)
    }

    enum cancelAll3: String, _StringRawRepresentable {
        case name = "cancelAll3"
    }
}

class MockPhotoStorageService: NSObject, PhotoStorageServicing {
    let invocations = _Invocations()
    let actions = _Actions()
    static let invocations = _Invocations()
    static let actions = _Actions()

    // MARK: - save

    func save(_ resources: [PhotoResource]) -> Result<Void, PhotoStorageError> {
        let functionName = save1.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: resources, forKey: save1.params.resources)
        invocations.record(invocation)
        return actions.returnValue(for: functionName) as! Result<Void, PhotoStorageError>
    }

    enum save1: String, _StringRawRepresentable {
        case name = "save1"
        enum params: String, _StringRawRepresentable {
            case resources = "save(_resources:[PhotoResource]).resources"
        }
    }

    // MARK: - load

    func load() -> Result<[PhotoResource], PhotoStorageError> {
        let functionName = load2.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocations.record(invocation)
        return actions.returnValue(for: functionName) as! Result<[PhotoResource], PhotoStorageError>
    }

    enum load2: String, _StringRawRepresentable {
        case name = "load2"
    }

    // MARK: - remove

    func remove(_ resources: [PhotoResource]) -> Result<[PhotoResource], PhotoStorageError> {
        let functionName = remove3.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: resources, forKey: remove3.params.resources)
        invocations.record(invocation)
        return actions.returnValue(for: functionName) as! Result<[PhotoResource], PhotoStorageError>
    }

    enum remove3: String, _StringRawRepresentable {
        case name = "remove3"
        enum params: String, _StringRawRepresentable {
            case resources = "remove(_resources:[PhotoResource]).resources"
        }
    }
}

class MockPreferencesController: NSViewController, PreferencesControllable {
    var preferences: Preferences {
        get { return _preferences }
        set(value) { _preferences = value; _preferencesHistory.append(_Variable(value)) }
    }
    var _preferences: Preferences!
    var _preferencesHistory: [_Variable<Preferences?>] = []
    let invocations = _Invocations()
    let actions = _Actions()
    static let invocations = _Invocations()
    static let actions = _Actions()

    // MARK: - open

    func open() {
        let functionName = open1.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocations.record(invocation)
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
    static let invocations = _Invocations()
    static let actions = _Actions()

    // MARK: - save

    func save(_ preferences: Preferences) -> Result<Void, PreferencesError> {
        let functionName = save1.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: preferences, forKey: save1.params.preferences)
        invocations.record(invocation)
        return actions.returnValue(for: functionName) as! Result<Void, PreferencesError>
    }

    enum save1: String, _StringRawRepresentable {
        case name = "save1"
        enum params: String, _StringRawRepresentable {
            case preferences = "save(_preferences:Preferences).preferences"
        }
    }

    // MARK: - load

    func load() -> Result<Preferences, PreferencesError> {
        let functionName = load2.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocations.record(invocation)
        return actions.returnValue(for: functionName) as! Result<Preferences, PreferencesError>
    }

    enum load2: String, _StringRawRepresentable {
        case name = "load2"
    }
}

class MockPreferencesViewController: NSViewController, PreferencesViewControllable {
    var viewState: PreferencesViewStating? {
        get { return _viewState }
        set(value) { _viewState = value; _viewStateHistory.append(_Variable(value)) }
    }
    var _viewState: PreferencesViewStating?
    var _viewStateHistory: [_Variable<PreferencesViewStating?>] = []
    let invocations = _Invocations()
    let actions = _Actions()
    static let invocations = _Invocations()
    static let actions = _Actions()

    // MARK: - setDelegate

    func setDelegate(_ delegate: PreferencesViewControllerDelegate) {
        let functionName = setDelegate1.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: delegate, forKey: setDelegate1.params.delegate)
        invocations.record(invocation)
    }

    enum setDelegate1: String, _StringRawRepresentable {
        case name = "setDelegate1"
        enum params: String, _StringRawRepresentable {
            case delegate = "setDelegate(_delegate:PreferencesViewControllerDelegate).delegate"
        }
    }
}

class MockSharingService: NSObject, SharingServicing {
    var subject: String? {
        get { return _subject }
        set(value) { _subject = value; _subjectHistory.append(_Variable(value)) }
    }
    var _subject: String?
    var _subjectHistory: [_Variable<String?>] = []
    var recipients: [String]? {
        get { return _recipients }
        set(value) { _recipients = value; _recipientsHistory.append(_Variable(value)) }
    }
    var _recipients: [String]? = []
    var _recipientsHistory: [_Variable<[String]?>] = []
    var messageBody: String? {
        get { return _messageBody }
        set(value) { _messageBody = value; _messageBodyHistory.append(_Variable(value)) }
    }
    var _messageBody: String?
    var _messageBodyHistory: [_Variable<String?>] = []
    let invocations = _Invocations()
    let actions = _Actions()
    static let invocations = _Invocations()
    static let actions = _Actions()

    // MARK: - canPerform

    func canPerform(withItems items: [Any]?) -> Bool {
        let functionName = canPerform1.name
        let invocation = _Invocation(name: functionName.rawValue)
        if let items = items {
            invocation.set(parameter: items, forKey: canPerform1.params.items)
        }
        invocations.record(invocation)
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
    }

    enum perform2: String, _StringRawRepresentable {
        case name = "perform2"
        enum params: String, _StringRawRepresentable {
            case items = "perform(withItemsitems:[Any]).items"
        }
    }
}

class MockStatusBar: NSObject, StatusBarable {
    let invocations = _Invocations()
    let actions = _Actions()
    static let invocations = _Invocations()
    static let actions = _Actions()

    // MARK: - statusItem

    func statusItem(withLength length: CGFloat) -> NSStatusItem {
        let functionName = statusItem1.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: length, forKey: statusItem1.params.length)
        invocations.record(invocation)
        return actions.returnValue(for: functionName) as! NSStatusItem
    }

    enum statusItem1: String, _StringRawRepresentable {
        case name = "statusItem1"
        enum params: String, _StringRawRepresentable {
            case length = "statusItem(withLengthlength:CGFloat).length"
        }
    }

    // MARK: - removeStatusItem

    func removeStatusItem(_ item: NSStatusItem) {
        let functionName = removeStatusItem2.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: item, forKey: removeStatusItem2.params.item)
        invocations.record(invocation)
    }

    enum removeStatusItem2: String, _StringRawRepresentable {
        case name = "removeStatusItem2"
        enum params: String, _StringRawRepresentable {
            case item = "removeStatusItem(_item:NSStatusItem).item"
        }
    }
}

class MockStatusItemable: NSObject, StatusItemable {
    let invocations = _Invocations()
    let actions = _Actions()
    static let invocations = _Invocations()
    static let actions = _Actions()

    // MARK: - statusItem

    func statusItem(withLength length: CGFloat) -> NSStatusItem {
        let functionName = statusItem1.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: length, forKey: statusItem1.params.length)
        invocations.record(invocation)
        return actions.returnValue(for: functionName) as! NSStatusItem
    }

    enum statusItem1: String, _StringRawRepresentable {
        case name = "statusItem1"
        enum params: String, _StringRawRepresentable {
            case length = "statusItem(withLengthlength:CGFloat).length"
        }
    }

    // MARK: - removeStatusItem

    func removeStatusItem(_ item: NSStatusItem) {
        let functionName = removeStatusItem2.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: item, forKey: removeStatusItem2.params.item)
        invocations.record(invocation)
    }

    enum removeStatusItem2: String, _StringRawRepresentable {
        case name = "removeStatusItem2"
        enum params: String, _StringRawRepresentable {
            case item = "removeStatusItem(_item:NSStatusItem).item"
        }
    }
}

class MockUserDefaults: NSObject, UserDefaultable {
    let invocations = _Invocations()
    let actions = _Actions()
    static let invocations = _Invocations()
    static let actions = _Actions()

    // MARK: - object

    func object(forKey defaultName: String) -> Any? {
        let functionName = object1.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: defaultName, forKey: object1.params.defaultName)
        invocations.record(invocation)
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
    }

    enum set2: String, _StringRawRepresentable {
        case name = "set2"
        enum params: String, _StringRawRepresentable {
            case value = "set(_value:Any?,forKeydefaultName:String).value"
            case defaultName = "set(_value:Any?,forKeydefaultName:String).defaultName"
        }
    }
}

class MockUserNotificationCenter: NSObject, UserNotificationCentering {
    let invocations = _Invocations()
    let actions = _Actions()
    static let invocations = _Invocations()
    static let actions = _Actions()

    // MARK: - deliver

    func deliver(_ notification: NSUserNotification) {
        let functionName = deliver1.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: notification, forKey: deliver1.params.notification)
        invocations.record(invocation)
    }

    enum deliver1: String, _StringRawRepresentable {
        case name = "deliver1"
        enum params: String, _StringRawRepresentable {
            case notification = "deliver(_notification:NSUserNotification).notification"
        }
    }
}

class MockWindowController: NSObject, WindowControlling {
    var contentViewController: NSViewController? {
        get { return _contentViewController }
        set(value) { _contentViewController = value; _contentViewControllerHistory.append(_Variable(value)) }
    }
    var _contentViewController: NSViewController? = NSViewController()
    var _contentViewControllerHistory: [_Variable<NSViewController?>] = []
    let invocations = _Invocations()
    let actions = _Actions()
    static let invocations = _Invocations()
    static let actions = _Actions()

    // MARK: - showWindow

    func showWindow(_ sender: Any?) {
        let functionName = showWindow1.name
        let invocation = _Invocation(name: functionName.rawValue)
        if let sender = sender {
            invocation.set(parameter: sender, forKey: showWindow1.params.sender)
        }
        invocations.record(invocation)
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
    static let invocations = _Invocations()
    static let actions = _Actions()

    // MARK: - open

    func open(_ preference: SystemPreference) -> Result<Void, WorkspaceError> {
        let functionName = open1.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: preference, forKey: open1.params.preference)
        invocations.record(invocation)
        return actions.returnValue(for: functionName) as! Result<Void, WorkspaceError>
    }

    enum open1: String, _StringRawRepresentable {
        case name = "open1"
        enum params: String, _StringRawRepresentable {
            case preference = "open(_preference:SystemPreference).preference"
        }
    }

    // MARK: - open

    func open(_ url: URL) -> Result<Void, WorkspaceError> {
        let functionName = open2.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: url, forKey: open2.params.url)
        invocations.record(invocation)
        return actions.returnValue(for: functionName) as! Result<Void, WorkspaceError>
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
    static let invocations = _Invocations()
    static let actions = _Actions()

    // MARK: - open

    func open(_ url: URL) -> Bool {
        let functionName = open1.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: url, forKey: open1.params.url)
        invocations.record(invocation)
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
