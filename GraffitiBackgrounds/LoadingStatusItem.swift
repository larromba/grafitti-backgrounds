import Cocoa

// sourcery: name = LoadingStatusItem
protocol LoadingStatusItemable: AnyObject, Mockable {
    var viewState: LoadingStatusItemViewState { get set }
    var menu: Menuable? { get set }

    func item<T: MenuItemable>(at index: Int) -> T?
}

final class LoadingStatusItem: LoadingStatusItemable {
    var viewState: LoadingStatusItemViewState {
        didSet { bind(viewState) }
    }
    var menu: Menuable? {
        get {
            return item.menu as? Menuable
        }
        set {
            item.menu = newValue as? NSMenu
        }
    }
    let statusBar: StatusBarable
    let item: NSStatusItem
    private var isLoading: Bool = false {
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
    private var loadingPercentage: Double {
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

    init(viewState: LoadingStatusItemViewState, statusBar: StatusBarable) {
        self.viewState = viewState
        self.statusBar = statusBar
        self.item = statusBar.statusItem(withLength: NSStatusItem.variableLength)
        bind(viewState)
    }

    deinit {
        statusBar.removeStatusItem(item)
    }

    func item<T: MenuItemable>(at index: Int) -> T? {
        return item.menu?.item(at: index) as? T
    }

    // MARK: - private

    private func bind(_ viewState: LoadingStatusItemViewState) {
        isLoading = viewState.isLoading
        loadingPercentage = viewState.loadingPercentage
        item.button?.alphaValue = viewState.alpha
        item.image = viewState.style.image
    }
}
