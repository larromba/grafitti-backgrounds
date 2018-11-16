import Foundation

enum Progress {
	static func normalize(progress: Double, forStepIndex stepIndex: UInt, inTotalSteps totalSteps: UInt) -> Double {
		guard progress >= 0, progress <= 1 else {
			assertionFailure("progress must be between 0 and 1")
			return 0
		}
		guard stepIndex < totalSteps else {
			assertionFailure("stepIndex must be < totalSteps")
			return 0
		}
		let min = Double(stepIndex) / Double(totalSteps)
		let max = Double(stepIndex + 1) / Double(totalSteps)
		return progress * (max - min) + min
	}
}
