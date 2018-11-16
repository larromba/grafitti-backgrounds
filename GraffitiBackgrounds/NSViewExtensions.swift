import Cocoa

extension NSView {
    func setCIColor(_ color: NSColor) {
        guard
            let filter = CIFilter(name: "CIColorPolynomial"),
            let calibratedColor = color.usingColorSpaceName(NSColorSpaceName.calibratedRGB) else {
                assertionFailure("error making CIFIlter")
                return
        }
        filter.setDefaults()
        filter.setValue(CIVector(x: calibratedColor.redComponent), forKey: "inputRedCoefficients")
        filter.setValue(CIVector(x: calibratedColor.greenComponent), forKey: "inputGreenCoefficients")
        filter.setValue(CIVector(x: calibratedColor.blueComponent), forKey: "inputBlueCoefficients")
        contentFilters = [filter]
    }
}
