import Cocoa

// sourcery: name = WorkspaceController
protocol WorkspaceControllable: Mockable {
    func open(_ preference: SystemPreference) -> Result<Void>
    func open(_ url: URL) -> Result<Void>
}

final class WorkspaceController: WorkspaceControllable {
    enum WorkspaceError: Error {
        case errorOpeningURL
    }

    private let workspace: Workspacing

    init(workspace: Workspacing) {
        self.workspace = workspace
    }

    func open(_ preference: SystemPreference) -> Result<Void> {
		return open(preference.url)
    }

    func open(_ url: URL) -> Result<Void> {
		if workspace.open(url) {
			return .success(())
		} else {
			return .failure(WorkspaceError.errorOpeningURL)
		}
    }
}
