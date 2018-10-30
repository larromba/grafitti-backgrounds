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
            spinnerColor: .named(.spinner)
        )
    }

    let isLoading: Bool
    let loadingPercentage: Double
    let style: Style
}
