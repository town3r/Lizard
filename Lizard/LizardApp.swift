// LizardApp.swift
import SwiftUI
import AVFoundation
import UIKit
import Combine

@main
struct LizardApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
        // Defer heavy initialization to background
        Task.detached(priority: .utility) {
            // Start beta feedback manager asynchronously
            await MainActor.run {
                BetaFeedbackManager.shared.start()
            }
        }
        
        // Configure audio session asynchronously to avoid blocking startup
        Task.detached(priority: .background) {
            await Self.configureAudioSessionAsync()
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(nil) // Allow system color scheme
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willTerminateNotification)) { _ in
                    // Clean up resources when app terminates
                    SoundPlayer.shared.cleanup()
                    BetaFeedbackManager.shared.stop()
                }
        }
    }
    
    @Sendable
    private static func configureAudioSessionAsync() async {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.ambient, mode: .default)
            try audioSession.setActive(true)
        } catch {
            print("Failed to configure audio session: \(error)")
        }
    }
}

// MARK: - App Delegate for Orientation Control
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Initialize orientation manager
        OrientationManager.shared.setup()
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        // This method is called synchronously by the system, so we need to access the orientation mask safely
        return MainActor.assumeIsolated {
            OrientationManager.shared.currentOrientationMask
        }
    }
}

// MARK: - Orientation Manager
@MainActor
class OrientationManager: ObservableObject {
    static let shared = OrientationManager()
    
    @Published var currentOrientationMask: UIInterfaceOrientationMask = .all
    private var orientationLock: String = "unlocked"
    
    private init() {
        // Load saved orientation preference
        orientationLock = UserDefaults.standard.string(forKey: "orientationLock") ?? "unlocked"
        updateOrientationMask()
    }
    
    nonisolated func setup() {
        // Listen for orientation lock changes
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(orientationLockChanged),
            name: .orientationLockChanged,
            object: nil
        )

        // Apply initial orientation
        Task { @MainActor in
            updateOrientationMask()
        }
    }
    
    @objc nonisolated private func orientationLockChanged() {
        DispatchQueue.main.async {
            let newOrientationLock = UserDefaults.standard.string(forKey: "orientationLock") ?? "unlocked"
            self.orientationLock = newOrientationLock
            self.updateOrientationMask()
            self.forceOrientationUpdate()
        }
    }
    
    private func updateOrientationMask() {
        let newMask: UIInterfaceOrientationMask
        
        switch orientationLock {
        case "portrait":
            newMask = .portrait
        case "landscapeLeft":
            newMask = .landscapeLeft
        case "landscapeRight":
            newMask = .landscapeRight
        case "landscape":
            newMask = .landscape
        default:
            newMask = .all
        }
        
        currentOrientationMask = newMask
    }
    
    private func forceOrientationUpdate() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        let currentMask = self.currentOrientationMask
        
        if #available(iOS 16.0, *) {
            let request = UIWindowScene.GeometryPreferences.iOS(interfaceOrientations: currentMask)
            windowScene.requestGeometryUpdate(request) { error in
                print("Failed to update orientation: \(error)")
            }
        } else {
            // Fallback for iOS 15 and earlier
            if let window = windowScene.windows.first {
                window.rootViewController?.setNeedsUpdateOfSupportedInterfaceOrientations()
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - Notification Extension
extension Notification.Name {
    nonisolated(unsafe) static let orientationLockChanged = Notification.Name("orientationLockChanged")
}
