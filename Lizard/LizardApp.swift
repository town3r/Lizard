// LizardApp.swift
import SwiftUI
import UIKit

@main
struct LizardApp: App {
    init() {
        // Keep audio working even in Silent mode / while mixing with others
        AudioSession.configure()
        
        // Start beta feedback manager for screenshot detection
        BetaFeedbackManager.shared.start()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willTerminateNotification)) { _ in
                    // Clean up resources when app terminates
                    SoundPlayer.shared.cleanup()
                    BetaFeedbackManager.shared.stop()
                }
        }
    }
}
