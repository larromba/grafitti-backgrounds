import Foundation

struct Alert {
	let title: String
	let text: String
}

// TODO: localize
extension Alert {
	static func error(_ error: Error) -> Alert {
		return Alert(title: "Error", text: error.localizedDescription)
	}

	static var reloadingPhotos: Alert {
		return Alert(title: "Refreshing...", text: "Your photos are now refreshing")
	}

	static var reloadPhotosSuccess: Alert {
		return Alert(title: "Success!", text: "Your photos were reloaded")
	}

	static var clearFolderSuccess: Alert {
		return Alert(title: "Success!", text: "Your photos were cleared")
	}
}
