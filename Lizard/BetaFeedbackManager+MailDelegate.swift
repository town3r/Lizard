// BetaFeedbackManager+MailDelegate.swift
import UIKit
import MessageUI

extension BetaFeedbackManager: MFMailComposeViewControllerDelegate {
    nonisolated func mailComposeController(
        _ controller: MFMailComposeViewController,
        didFinishWith result: MFMailComposeResult,
        error: Error?
    ) {
        Task { @MainActor in
            controller.dismiss(animated: true)
        }
    }
}

extension BetaFeedbackManager {
    @MainActor
    func presentFeedbackComposer() {
        guard MFMailComposeViewController.canSendMail() else { return }
        let mail = MFMailComposeViewController()
        mail.mailComposeDelegate = self
        mail.setSubject("Lizard App Feedback")
        mail.setToRecipients(["support@town3r.com"])
        mail.setMessageBody("""
        Device: \(UIDevice.current.model) \(UIDevice.current.systemName) \(UIDevice.current.systemVersion)
        App: Lizard

        Describe your feedback here:
        """, isHTML: false)
        topViewController()?.present(mail, animated: true)
    }
}
