// BetaFeedbackManager.swift
import UIKit

/// Screenshot-to-feedback helper used during TestFlight.
@MainActor
final class BetaFeedbackManager: NSObject {
    static let shared = BetaFeedbackManager()

    private var screenshotObserver: NSObjectProtocol?

    /// Start listening for screenshots.
    func start() {
        guard screenshotObserver == nil else { return }
        screenshotObserver = NotificationCenter.default.addObserver(
            forName: UIApplication.userDidTakeScreenshotNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            Task { @MainActor in
                self?.showFeedbackSheet()
            }
        }
    }

    /// Stop listening.
    func stop() {
        if let o = screenshotObserver {
            NotificationCenter.default.removeObserver(o)
            screenshotObserver = nil
        }
    }

    /// Present the feedback UI (currently mail composer).
    /// NOTE: must be public/internal, NOT private.
    func showFeedbackSheet() {
        presentFeedbackComposer()
    }
}
