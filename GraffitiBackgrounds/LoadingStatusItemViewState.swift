import Cocoa

struct LoadingStatusItemViewState {
    struct Style {
        let image: NSImage
        let loadingImage: NSImage
        let spinnerColor: NSColor

        init(image: NSImage, loadingImage: NSImage, spinnerColor: NSColor) {
            self.image = image
            self.loadingImage = loadingImage
            self.spinnerColor = spinnerColor

            image.isTemplate = true
            loadingImage.isTemplate = true
        }

        static var sprayCan = Style(
            image: #imageLiteral(resourceName: "spray-can"),
            loadingImage: #imageLiteral(resourceName: "download"),
            spinnerColor: Asset.Colors.spinner.color
        )
    }

    let isLoading: Bool
    let loadingPercentage: Double
    let style: Style
    let alpha: CGFloat

    func copy(isLoading: Bool) -> LoadingStatusItemViewState {
        return LoadingStatusItemViewState(
            isLoading: isLoading,
            loadingPercentage: loadingPercentage,
            style: style,
            alpha: alpha
        )
    }

    func copy(loadingPercentage: Double) -> LoadingStatusItemViewState {
        return LoadingStatusItemViewState(
            isLoading: isLoading,
            loadingPercentage: loadingPercentage,
            style: style,
            alpha: alpha
        )
    }

    func copy(alpha: CGFloat) -> LoadingStatusItemViewState {
        return LoadingStatusItemViewState(
            isLoading: isLoading,
            loadingPercentage: loadingPercentage,
            style: style,
            alpha: alpha
        )
    }
}
