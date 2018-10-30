import Cocoa

// sourcery: name = LoadingStatusItem
protocol LoadingStatusItemable: Mockable {
    var isLoading: Bool { get }
    var loadingPercentage: Double { get }
    var viewState: LoadingStatusItemViewState { get set }
    var menu: Menuable? { get set }

    func item(at index: Int) -> MenuItemable?
}

final class LoadingStatusItem: LoadingStatusItemable {
    private(set) var statusBar: NSStatusBar
    private(set) var item: NSStatusItem
    private(set) var isLoading: Bool = false {
        didSet {
            if isLoading {
                item.image = viewState.style.loadingImage
                item.button?.addSubview(spinner)
                spinner.startAnimation(self)
            } else {
                item.image = viewState.style.image
                spinner.removeFromSuperview()
                spinner.stopAnimation(self)
                loadingPercentage = 0
            }
        }
    }
    private(set) var loadingPercentage: Double {
        get {
            return spinner.doubleValue
        }
        set {
            spinner.doubleValue = newValue
            spinner.displayIfNeeded()
        }
    }
    private lazy var spinner: NSProgressIndicator = {
        let size = item.button?.visibleRect.width ?? 0
        let height: CGFloat = size * 0.17 // 17%
        let spinner = NSProgressIndicator(frame: NSRect(x: 0, y: size - height, width: size, height: height))
        spinner.style = .bar
        spinner.wantsLayer = true
        spinner.setCIColor(viewState.style.spinnerColor)
        spinner.isIndeterminate = false
        spinner.minValue = 0.0
        spinner.maxValue = 1.0
        spinner.doubleValue = 0.0
        return spinner
    }()

    var viewState: LoadingStatusItemViewState {
        didSet {
            update(viewState: viewState)
        }
    }
    var menu: Menuable? {
        get {
            return item.menu as? Menuable
        }
        set {
            item.menu = newValue as? NSMenu
        }
    }

    init(viewState: LoadingStatusItemViewState, statusBar: NSStatusBar) {
        self.viewState = viewState
        self.statusBar = statusBar
        self.item = statusBar.statusItem(withLength: NSStatusItem.variableLength)
        item.image = viewState.style.image
    }

    deinit {
        statusBar.removeStatusItem(item)
    }

    func item(at index: Int) -> MenuItemable? {
        return item.menu?.item(at: index) as? MenuItemable
    }

    // MARK: - private

    private func update(viewState: LoadingStatusItemViewState) {
        isLoading = viewState.isLoading
        loadingPercentage = viewState.loadingPercentage
    }
}
