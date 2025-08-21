// WatchGameCenterManager.swift - Simplified GameCenter for watchOS
import GameKit

/// Simplified GameCenter manager for watchOS with basic functionality
final class WatchGameCenterManager {
    static let shared = WatchGameCenterManager()
    
    private init() {}
    
    // Simplified achievement IDs
    struct AchievementIDs {
        static let first50 = "com.town3r.lizard.watch.first50"
        static let first100 = "com.town3r.lizard.watch.first100"
        static let tap50 = "com.town3r.lizard.watch.tap50"
    }
    
    // Simplified leaderboard IDs
    struct LeaderboardIDs {
        static let totalSpawned = "com.town3r.lizard.watch.totalspawned"
        static let buttonTaps = "com.town3r.lizard.watch.buttontaps"
    }
    
    func authenticate() {
        guard GKLocalPlayer.local.authenticateHandler == nil else { return }
        
        GKLocalPlayer.local.authenticateHandler = { _, error in
            if let error = error {
                print("GameCenter authentication error: \(error)")
            } else {
                print("GameCenter authenticated: \(GKLocalPlayer.local.isAuthenticated)")
            }
        }
    }
    
    func reportScore(totalSpawned: Int, buttonTaps: Int) {
        guard GKLocalPlayer.local.isAuthenticated else { return }
        
        // Report to leaderboards
        GKLeaderboard.submitScore(
            totalSpawned,
            context: 0,
            player: GKLocalPlayer.local,
            leaderboardIDs: [LeaderboardIDs.totalSpawned]
        ) { error in
            if let error = error {
                print("Failed to submit total spawned score: \(error)")
            }
        }
        
        GKLeaderboard.submitScore(
            buttonTaps,
            context: 0,
            player: GKLocalPlayer.local,
            leaderboardIDs: [LeaderboardIDs.buttonTaps]
        ) { error in
            if let error = error {
                print("Failed to submit button taps score: \(error)")
            }
        }
    }
    
    func reportAchievements(totalSpawned: Int, buttonTaps: Int) {
        guard GKLocalPlayer.local.isAuthenticated else { return }
        
        var achievements: [GKAchievement] = []
        
        // Simple achievements for watchOS
        if totalSpawned >= 50 {
            let achievement = GKAchievement(identifier: AchievementIDs.first50)
            achievement.percentComplete = 100
            achievement.showsCompletionBanner = true
            achievements.append(achievement)
        }
        
        if totalSpawned >= 100 {
            let achievement = GKAchievement(identifier: AchievementIDs.first100)
            achievement.percentComplete = 100
            achievement.showsCompletionBanner = true
            achievements.append(achievement)
        }
        
        if buttonTaps >= 50 {
            let achievement = GKAchievement(identifier: AchievementIDs.tap50)
            achievement.percentComplete = 100
            achievement.showsCompletionBanner = true
            achievements.append(achievement)
        }
        
        guard !achievements.isEmpty else { return }
        
        GKAchievement.report(achievements) { error in
            if let error = error {
                print("Failed to report achievements: \(error)")
            }
        }
    }
}