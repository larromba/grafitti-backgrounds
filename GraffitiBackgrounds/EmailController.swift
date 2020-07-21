import Foundation

// sourcery: name = EmailController
protocol EmailControlling: Mockable {
    func openMail(receipient: String, subject: String, body: String) -> Result<Void, EmailError>
}

final class EmailController: EmailControlling {
    private let sharingService: SharingServicing?

    init(sharingService: SharingServicing?) {
        self.sharingService = sharingService
    }

    func openMail(receipient: String, subject: String, body: String) -> Result<Void, EmailError> {
        guard let sharingService = sharingService else {
            return .failure(.serviceNotAvailable)
        }
        sharingService.recipients = [receipient]
        sharingService.subject = subject
        let items = [body]
        guard sharingService.canPerform(withItems: items) else {
            return .failure(.serviceNotAvailable)
        }
        sharingService.perform(withItems: items)
        return .success(())
    }
}
