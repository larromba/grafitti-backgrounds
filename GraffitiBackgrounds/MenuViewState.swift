import Cocoa

protocol MenuViewStating {
    var title: String { get }
    var autoenablesItems: Bool { get }
    var items: [NSMenuItem] { get }
}

struct MenuViewState: MenuViewStating {
    let title: String
    let autoenablesItems: Bool
    let items: [NSMenuItem]
}
