import Cocoa

protocol LoadingStatusItemViewStating {
    var isLoading: Bool { get }
    var loadingPercentage: Double { get }
    var image: NSImage { get }
    var loadingImage: NSImage { get }
    var spinnerColor: NSColor { get }
    var alpha: CGFloat { get }

    func copy(isLoading: Bool) -> LoadingStatusItemViewStating
    func copy(loadingPercentage: Double) -> LoadingStatusItemViewStating
    func copy(alpha: CGFloat) -> LoadingStatusItemViewStating
}

struct LoadingStatusItemViewState: LoadingStatusItemViewStating {
    let isLoading: Bool
    let loadingPercentage: Double
    let image: NSImage
    let loadingImage: NSImage
    let spinnerColor: NSColor
    let alpha: CGFloat

    init(isLoading: Bool = false, loadingPercentage: Double = 0, image: NSImage = Asset.Assets.sprayCan.image,
         loadingImage: NSImage = Asset.Assets.download.image, spinnerColor: NSColor = Asset.Colors.spinner.color,
         alpha: CGFloat = 1.0) {
        self.isLoading = isLoading
        self.loadingPercentage = loadingPercentage
        self.image = image
        self.loadingImage = loadingImage
        self.spinnerColor = spinnerColor
        self.alpha = alpha

        image.isTemplate = true
        loadingImage.isTemplate = true
    }
}

extension LoadingStatusItemViewState {
    func copy(isLoading: Bool) -> LoadingStatusItemViewStating {
        return LoadingStatusItemViewState(
            isLoading: isLoading,
            loadingPercentage: loadingPercentage,
            image: image,
            loadingImage: loadingImage,
            spinnerColor: spinnerColor,
            alpha: alpha
        )
    }

    func copy(loadingPercentage: Double) -> LoadingStatusItemViewStating {
        return LoadingStatusItemViewState(
            isLoading: isLoading,
            loadingPercentage: loadingPercentage,
            image: image,
            loadingImage: loadingImage,
            spinnerColor: spinnerColor,
            alpha: alpha
        )
    }

    func copy(alpha: CGFloat) -> LoadingStatusItemViewStating {
        return LoadingStatusItemViewState(
            isLoading: isLoading,
            loadingPercentage: loadingPercentage,
            image: image,
            loadingImage: loadingImage,
            spinnerColor: spinnerColor,
            alpha: alpha
        )
    }
}
