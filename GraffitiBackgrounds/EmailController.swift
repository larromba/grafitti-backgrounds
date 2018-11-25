import Foundation
import Result

// sourcery: name = EmailController
protocol EmailControlling: Mockable {
    func openMail(receipient: String, subject: String, body: String) -> Result<Void>
}

final class EmailController: EmailControlling {
    private let sharingService: SharingServicing?

    init(sharingService: SharingServicing?) {
        self.sharingService = sharingService
    }

    func openMail(receipient: String, subject: String, body: String) -> Result<Void> {
        guard let sharingService = sharingService else {
            return .failure(EmailError.serviceNotAvailable)
        }
        sharingService.recipients = [receipient]
        sharingService.subject = subject
        let items = [body]
        guard sharingService.canPerform(withItems: items) else {
            return .failure(EmailError.serviceNotAvailable)
        }
        sharingService.perform(withItems: items)
        return .success(())
    }
}
