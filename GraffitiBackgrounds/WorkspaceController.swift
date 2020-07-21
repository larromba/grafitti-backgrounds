import Cocoa

// sourcery: name = WorkspaceController
protocol WorkspaceControllable: Mockable {
    func open(_ preference: SystemPreference) -> Result<Void, WorkspaceError>
    func open(_ url: URL) -> Result<Void, WorkspaceError>
}

final class WorkspaceController: WorkspaceControllable {
    private let workspace: Workspacing

    init(workspace: Workspacing) {
        self.workspace = workspace
    }

    func open(_ preference: SystemPreference) -> Result<Void, WorkspaceError> {
        return open(preference.url)
    }

    func open(_ url: URL) -> Result<Void, WorkspaceError> {
        if workspace.open(url) {
            return .success(())
        } else {
            return .failure(.errorOpeningURL)
        }
    }
}
