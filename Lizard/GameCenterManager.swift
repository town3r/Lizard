// GameCenterManager.swift
import Foundation
import GameKit
import UIKit

/// A tiny, modern wrapper around GameKit for iOS 18 / SDK 26.
final class GameCenterManager: NSObject, @unchecked Sendable {

    @MainActor static let shared = GameCenterManager()

    // MARK: - Authentication

    /// Call once on launch (e.g. from ContentView.onAppear).
    func authenticate(presentingViewController: @escaping @MainActor () -> UIViewController?) {
        GKLocalPlayer.local.authenticateHandler = { vc, error in
            if let vc = vc {
                DispatchQueue.main.async {
                    presentingViewController()?.present(vc, animated: true, completion: nil)
                }
                return
            }
            if let error { print("Game Center auth error:", error) }
        }
    }

    // MARK: - Access Point (trophy icon)

    /// Configure and show the floating trophy icon.
    /// `showsHighlights` is deprecated on iOS 26 and is ignored here.
    func configureAccessPoint(
        isActive: Bool = true,
        location: GKAccessPoint.Location = .topLeading
    ) {
        let ap = GKAccessPoint.shared
        ap.location = location
        ap.isActive = isActive
        // ap.showHighlights = ...  // deprecated on iOS 26
    }

    /// Programmatically open the same dashboard the access point shows.
    func presentLeaderboards() {
        guard GKLocalPlayer.local.isAuthenticated else { return }
        GKAccessPoint.shared.trigger { }   // empty-parameter closure in iOS 18
    }

    /// Try to open to a specific leaderboard.
    /// On iOS 26 the public API no longer guarantees deep-linking to an ID,
    /// so we fall back to the standard dashboard.
    func presentLeaderboards(leaderboardID: String) {
        presentLeaderboards()
    }

    // MARK: - Leaderboards (new API)

    /// Report one or more scores. `context` can be your level/mode; leave 0 if unused.
    func report(scores: [(id: String, value: Int)], context: Int = 0) {
        guard GKLocalPlayer.local.isAuthenticated else { return }

        for s in scores {
            GKLeaderboard.submitScore(
                s.value,                       // Int (not Int64)
                context: context,
                player: GKLocalPlayer.local,
                leaderboardIDs: [s.id]
            ) { error in
                if let error {
                    print("GameKit submitScore error (\(s.id)): \(error)")
                }
            }
        }
    }

    // MARK: - Achievements (API unchanged)

    struct AchIDs {
        static let first100  = "com.town3r.lizard.ach.first100"
        static let first500  = "com.town3r.lizard.ach.first500"
        static let tap100    = "com.town3r.lizard.ach.tap100"
    }

    func reportAchievements(totalSpawned: Int, buttonTaps: Int) {
        var toReport: [GKAchievement] = []

        if totalSpawned >= 100 {
            let a = GKAchievement(identifier: AchIDs.first100)
            a.percentComplete = 100
            a.showsCompletionBanner = true
            toReport.append(a)
        }
        if totalSpawned >= 500 {
            let a = GKAchievement(identifier: AchIDs.first500)
            a.percentComplete = 100
            a.showsCompletionBanner = true
            toReport.append(a)
        }
        if buttonTaps >= 100 {
            let a = GKAchievement(identifier: AchIDs.tap100)
            a.percentComplete = 100
            a.showsCompletionBanner = true
            toReport.append(a)
        }

        guard !toReport.isEmpty else { return }

        GKAchievement.report(toReport) { error in
            if let error { print("GameKit achievements report error:", error) }
        }
    }
}
