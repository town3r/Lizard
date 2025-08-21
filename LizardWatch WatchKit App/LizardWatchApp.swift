// LizardWatchApp.swift
import SwiftUI

@main
struct LizardWatchApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onReceive(NotificationCenter.default.publisher(for: .NSExtensionHostWillTerminate)) { _ in
                    // Clean up resources when app terminates
                    WatchSoundPlayer.shared.cleanup()
                }
        }
    }
}